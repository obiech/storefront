part of 'search_location_page.dart';

class SearchLocationPageWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const SearchLocationPageWrapper({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchLocationBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SearchLocationPage();
  }
}
