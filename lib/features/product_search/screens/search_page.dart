import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

import '../../home/index.dart';
import '../index.dart';

class SearchPage extends StatefulWidget implements AutoRouteWrapper {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<SearchHistoryCubit>()..getSearchQueries(),
        ),
        BlocProvider(
          create: (_) => getIt<AutosuggestionBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<SearchInventoryCubit>(),
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

  /// States
  /// * Default State
  /// * Empty state
  /// * Autocomplete
  /// * Product Search

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return BlocListener<HomeNavCubit, HomeNavState>(
      listenWhen: (prevState, currentState) =>
          prevState.route != SearchRoute.name &&
          currentState.route == SearchRoute.name,
      listener: (context, state) {
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
            _pageState.value = SearchPageState.AUTO_SUGGESTIONS;
            context.read<AutosuggestionBloc>().add(GetSuggestions(query));
          },
          onSearch: (query) {
            _pageState.value = SearchPageState.PRODUCT_SEARCH;
            context.read<SearchHistoryCubit>().addSearchQuery(query);

            /// Set-off search to search service
            context.read<SearchInventoryCubit>().searchInventory(query);
          },
        ),
        // bodyAlignment: Alignment.topCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ValueListenableBuilder<SearchPageState>(
              valueListenable: _pageState,
              builder: (_, state, __) {
                switch (state) {
                  case SearchPageState.DEFAULT:
                    return SearchHistory(
                      onItemTapped: _searchItemTapped,
                    );
                  case SearchPageState.AUTO_SUGGESTIONS:
                    return SearchSuggestion(
                      onItemTapped: _searchItemTapped,
                    );
                  case SearchPageState.PRODUCT_SEARCH:
                    return const SearchResults();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _searchItemTapped() {
    _focusNode.unfocus();
    _controller.clear();
    _pageState.value = SearchPageState.PRODUCT_SEARCH;
  }

  /// Manage conditions when focus should be requested
  void _setUpPage({bool reqFocus = true}) {
    final searchInventoryState = context.read<SearchInventoryCubit>().state;
    if (searchInventoryState is InventoryItemResults &&
        searchInventoryState.results.isNotEmpty) {
      _pageState.value = SearchPageState.PRODUCT_SEARCH;
      _focusNode.unfocus();
    } else {
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

enum SearchPageState { DEFAULT, AUTO_SUGGESTIONS, PRODUCT_SEARCH }
