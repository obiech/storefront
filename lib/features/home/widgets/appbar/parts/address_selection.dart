part of '../appbar.dart';

/// Address Selection widget in [HomeAppBar].
///
/// Will be displayed when user is logged in.
/// Otherwise, [PromptLoginOrRegister] will be displayed instead.
class AddressSelection extends StatelessWidget {
  @visibleForTesting
  const AddressSelection({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF2F3142),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(
                DropezyIcons.pin,
                size: 14,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BlocBuilder<DeliveryAddressCubit, DeliveryAddressState>(
                  builder: (context, state) {
                    if (state is DeliveryAddressLoaded) {
                      return Text(
                        state.activeAddress.title,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: context.res.colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    } else if (state is DeliveryAddressLoading) {
                      return const AddressSelectionLoading();
                    } else if (state is DeliveryAddressError) {
                      return AddressSelectionError(message: state.message);
                    }

                    return Container();
                  },
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                DropezyIcons.chevron_down,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A loading widget for Address Selection
/// in the form of Rounded Rectangle skeleton
class AddressSelectionLoading extends StatelessWidget {
  const AddressSelectionLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      isLoading: true,
      skeleton: SkeletonLine(
        style: SkeletonLineStyle(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Container(),
    );
  }
}

/// One-liner error message in red color
class AddressSelectionError extends StatelessWidget {
  const AddressSelectionError({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      maxLines: 1,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: context.res.colors.red,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
