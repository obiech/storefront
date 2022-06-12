import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

// TODO (widy): Fix translations
// https://dropezy.atlassian.net/browse/STOR-622
class SearchLocationResult extends StatelessWidget {
  const SearchLocationResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.res.dimens.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<SearchLocationBloc, SearchLocationState>(
            builder: (context, state) {
              if (state is SearchLocationInitial) {
                return Text(
                  'Terakhir Dicari',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ).withLineHeight(22),
                );
              } else {
                return Text(
                  'Saran',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ).withLineHeight(22),
                );
              }
            },
          ),
          const SizedBox(height: 8),
          Flexible(
            child: MultiBlocListener(
              listeners: [
                /// Handle when getting location detail is success
                BlocListener<SearchLocationBloc, SearchLocationState>(
                  listenWhen: (prev, current) =>
                      current is LocationSelectSuccess,
                  listener: (context, state) {
                    if (state is LocationSelectSuccess) {
                      context.pushRoute(
                        AddressDetailRoute(
                          placeDetails: state.addressDetails,
                        ),
                      );
                    }
                  },
                ),

                /// Handle when getting location detail is fail
                BlocListener<SearchLocationBloc, SearchLocationState>(
                  listenWhen: (prev, current) => current is LocationSelectError,
                  listener: (context, state) {
                    if (state is LocationSelectError) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(DropezySnackBar.info(state.message));
                    }
                  },
                ),
              ],
              child: BlocBuilder<SearchLocationBloc, SearchLocationState>(
                builder: (context, state) {
                  if (state is SearchLocationLoaded) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        final place = state.results[index];

                        return PlaceSuggestionTile(
                          place: place,
                          onTap: () {
                            context
                                .read<SearchLocationBloc>()
                                .add(LocationSelected(place.placeId ?? ''));
                          },
                        );
                      },
                      itemCount: state.results.length,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    );
                  } else if (state is SearchLocationInitial) {
                    // TODO (widy): show search history
                    // https://dropezy.atlassian.net/browse/STOR-621
                    return const SizedBox.shrink();
                  } else if (state is SearchLocationLoadedEmpty) {
                    return const Text("Can't find address");
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
