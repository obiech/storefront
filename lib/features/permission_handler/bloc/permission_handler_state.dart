part of 'permission_handler_cubit.dart';

abstract class PermissionHandlerState extends Equatable {
  const PermissionHandlerState();
}

class PermissionLoading extends PermissionHandlerState {
  const PermissionLoading();

  @override
  List<Object> get props => [];
}

class PermissionGranted extends PermissionHandlerState {
  const PermissionGranted();

  @override
  List<Object> get props => [];
}

class PermissionDenied extends PermissionHandlerState {
  const PermissionDenied();

  @override
  List<Object> get props => [];
}

class PermissionPermanentlyDenied extends PermissionHandlerState {
  const PermissionPermanentlyDenied();

  @override
  List<Object> get props => [];
}

class PermissionRestricted extends PermissionHandlerState {
  const PermissionRestricted();

  @override
  List<Object> get props => [];
}

class PermissionLimited extends PermissionHandlerState {
  const PermissionLimited();

  @override
  List<Object> get props => [];
}
