part of 'search_location_page.dart';

class SearchLocationPageWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const SearchLocationPageWrapper({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<SearchLocationBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<SearchLocationHistoryBloc>()
            ..add(const LoadSearchLocationHistory()),
        )
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SearchLocationPage();
  }
}
