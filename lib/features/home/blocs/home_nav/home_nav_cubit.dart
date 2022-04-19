import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// [Cubit] to handle the current [PageState] of the home page
@singleton
class HomeNavCubit extends Cubit<HomeNavState> {
  HomeNavCubit() : super(const HomeNavState(PageState.NOTHING, ''));

  void routeChanged(HomeNavState state) => emit(state);
}

/// Home page navigation state
class HomeNavState extends Equatable {
  /// The state of the current page
  final PageState state;

  /// The route name
  final String route;

  const HomeNavState(this.state, this.route);

  @override
  List<Object?> get props => [state, route];
}

/// Tab page state
enum PageState {
  /// Default page state for the cubit
  NOTHING,

  /// When the page is newly added to the route stack
  DID_PUSH,

  /// When the tab  is newly setup
  DID_INIT_TAB_ROUTE,

  /// When the tab state  is changed
  DID_CHANGE_TAB_ROUTE,
}
