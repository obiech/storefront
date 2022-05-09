import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

import '../../home/index.dart';
import '../index.dart';

/// The inventory and product discovery page.
/// [PRD](https://dropezy.atlassian.net/wiki/spaces/STOR/pages/7897122/Discovery+Through+Search)
///
/// Search page has mainly two states :-
///
/// * [SearchPageState.DEFAULT] - This is when no search has been done or when
/// the search text field is focused for the first time.
/// It acts as a placeholder state during search.
///
/// This state displays search history [SearchHistory] if a search has been done
/// before and default search [DefaultSearchPage] message (now)/
/// recommendations (In future)
///
/// * [SearchPageState.PRODUCT_SEARCH] - This serves as the search state during
/// an active search, it involves mainly two actions,
/// autosuggestions [SearchSuggestion] and inventory search [SearchResults].
///
/// This page state is triggered when the [SearchTextField] text is changed or
/// when the [SearchTextField] search button is tapped on the keyboard.
///
/// During search, two consecutive queries are sent to the [AutosuggestionBloc]
/// for autosuggestions and [SearchInventoryCubit] for inventory search and
/// displayed concurrently as their responses are received.
///
/// ## [SearchTextField]
/// This is the most integral trigger for search other than tapping on
/// [SearchHistory] or autosuggestions. It triggers search page state change
/// in mainly three scenarios :-
///
/// * FOCUS - When it's focused, the [SearchPageState.DEFAULT] should be
/// triggered showing the [SearchHistory] if any.
///
/// * TEXT CHANGED - When it's text is changed at a buffer of 3 characters
/// and above a search query should be made for autosuggestions and inventory search.
///
/// * SUBMITTED - When the **Search Button** is tapped on the keyboard, this
/// scenario should be triggered and search queries above sent.
///
/// * CLEARED - When the **Clear Button** is tapped, reset the page to default
/// state & focus the search field.
///
/// ## Return States
///
/// - When a user is returning to the search page, if a search was done before,
/// it should be displayed instantly.
///
/// - However, if no search was made before, proceed as a fresh search.
class SearchPage extends StatefulWidget implements AutoRouteWrapper {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<SearchHistoryCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<AutosuggestionBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<SearchInventoryBloc>(),
        ),
      ],
      child: this,
    );
  }
}

class _SearchPageState extends State<SearchPage> with RouteAware {
  late FocusNode _focusNode;
  late ValueNotifier<SearchPageState> _pageState;
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return BlocListener<HomeNavCubit, HomeNavState>(
      listenWhen: (prevState, currentState) =>
          prevState.route != SearchRoute.name &&
          currentState.route == SearchRoute.name,
      listener: (context, state) {
        /// Trigger fresh [SearchPageState] when user
        /// is returning to Search bottom sheet tab.
        _setUpPage();
      },
      child: DropezyScaffold(
        useRoundedBody: true,
        toolbarHeight: res.dimens.appBarSize + 20,
        bodyAlignment: Alignment.topCenter,
        title: SearchTextField(
          focusNode: _focusNode,
          controller: _controller,
          placeholder: res.strings.findYourNeeds,
          onFocusChanged: (focused) {
            if (focused) {
              if (_pageState.value != SearchPageState.DEFAULT) {
                _pageState.value = SearchPageState.DEFAULT;
              }
            } else {
              _setUpPage(reqFocus: false);
            }
          },
          onTextChanged: (query) {
            _pageState.value = SearchPageState.PRODUCT_SEARCH;
            context.read<AutosuggestionBloc>().add(GetSuggestions(query));

            /// Set-off search to search service
            context.read<SearchInventoryBloc>().add(SearchInventory(query));
          },
          onSearch: (query) {
            _pageState.value = SearchPageState.PRODUCT_SEARCH;
            context.read<SearchHistoryCubit>().addSearchQuery(query);

            /// Set-off search to search service
            context.read<SearchInventoryBloc>().add(SearchInventory(query));
          },
          onCleared: () {
            /// Reset State
            _pageState.value = SearchPageState.DEFAULT;
            _focusNode.requestFocus();
          },
        ),
        child: SizedBox(
          height:
              MediaQuery.of(context).size.height - (res.dimens.appBarSize + 20),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              ///Bottom Nav Padding
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: ValueListenableBuilder<SearchPageState>(
                valueListenable: _pageState,
                builder: (_, state, __) {
                  switch (state) {
                    case SearchPageState.DEFAULT:
                      return SearchHistory(
                        onItemTapped: _searchItemTapped,
                      );
                    case SearchPageState.PRODUCT_SEARCH:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchSuggestion(
                            onItemTapped: _searchItemTapped,
                          ),
                          const SearchResults(),
                        ],
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// When [SearchHistory] or [SearchSuggestion] item
  /// is tapped, reset [SearchTextField]
  void _searchItemTapped() {
    _focusNode.unfocus();
    _controller.clear();
    _pageState.value = SearchPageState.PRODUCT_SEARCH;
  }

  /// Manage conditions when focus should be requested
  void _setUpPage({bool reqFocus = true}) {
    final searchInventoryState = context.read<SearchInventoryBloc>().state;

    // Returning User who already has some search results
    if (searchInventoryState is InventoryItemResults &&
        searchInventoryState.results.isNotEmpty) {
      _pageState.value = SearchPageState.PRODUCT_SEARCH;
      _focusNode.unfocus();
    }
    // Fresh search, with no previous search in current session
    else {
      if (reqFocus) _focusNode.requestFocus();
    }
  }

  @override
  void initState() {
    _focusNode = FocusNode();
    _controller = TextEditingController();
    _pageState = ValueNotifier(SearchPageState.DEFAULT);
    _setUpPage();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

/// Search Page States
///
/// Can change in future when more use cases are required
enum SearchPageState {
  /// Fresh search, no search has been done before or [SearchTextField]
  /// has been focused
  DEFAULT,

  /// Search is currently being done, [SearchTextField] text has changed or
  /// search button has been tapped
  PRODUCT_SEARCH
}
