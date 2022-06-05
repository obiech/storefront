import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:storefront_app/core/utils/dropezy_permission_handler.dart';

part 'permission_handler_state.dart';

@Injectable()
class PermissionHandlerCubit extends Cubit<PermissionHandlerState> {
  final DropezyPermissionHandler _dropezyPermissionHandler;

  PermissionHandlerCubit(DropezyPermissionHandler dropezyPermissionHandler)
      : _dropezyPermissionHandler = dropezyPermissionHandler,
        super(const PermissionLoading());

  Future<void> requestPermission(Permission permission) async {
    emit(const PermissionLoading());
    final status =
        await _dropezyPermissionHandler.requestPermission(permission);
    switch (status) {
      case PermissionStatus.granted:
        emit(const PermissionGranted());
        break;
      case PermissionStatus.denied:
        emit(const PermissionDenied());
        break;
      case PermissionStatus.permanentlyDenied:
        emit(const PermissionPermanentlyDenied());
        break;
      case PermissionStatus.restricted:
        emit(const PermissionRestricted());
        break;
      case PermissionStatus.limited:
        emit(const PermissionLimited());
        break;
    }
  }
}
