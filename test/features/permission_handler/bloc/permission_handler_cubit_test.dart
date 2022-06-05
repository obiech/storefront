import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:storefront_app/core/utils/dropezy_permission_handler.dart';
import 'package:storefront_app/features/permission_handler/index.dart';

import '../mocks.dart';

void main() {
  late DropezyPermissionHandler permissionHandler;
  late PermissionHandlerCubit permissionHandlerCubit;
  const locationPermission = Permission.location;

  setUp(() {
    permissionHandler = MockPermissionHandler();
    permissionHandlerCubit = PermissionHandlerCubit(permissionHandler);
  });

  test('initial state is PermissionLoading', () {
    expect(permissionHandlerCubit.state, const PermissionLoading());
  });

  blocTest<PermissionHandlerCubit, PermissionHandlerState>(
    'emit PermissionGranted '
    'when permissionHandler request is granted',
    setUp: () {
      when(() => permissionHandler.requestPermission(locationPermission))
          .thenAnswer((_) async => PermissionStatus.granted);
    },
    build: () => permissionHandlerCubit,
    act: (cubit) => cubit.requestPermission(locationPermission),
    expect: () => [
      const PermissionLoading(),
      const PermissionGranted(),
    ],
  );

  blocTest<PermissionHandlerCubit, PermissionHandlerState>(
    'emit PermissionDenied '
    'when permissionHandler request is denied',
    setUp: () {
      when(() => permissionHandler.requestPermission(locationPermission))
          .thenAnswer((_) async => PermissionStatus.denied);
    },
    build: () => permissionHandlerCubit,
    act: (cubit) => cubit.requestPermission(locationPermission),
    expect: () => [
      const PermissionLoading(),
      const PermissionDenied(),
    ],
  );

  blocTest<PermissionHandlerCubit, PermissionHandlerState>(
    'emit PermissionPermanentlyDenied '
    'when permissionHandler request is permanentlyDenied',
    setUp: () {
      when(() => permissionHandler.requestPermission(locationPermission))
          .thenAnswer((_) async => PermissionStatus.permanentlyDenied);
    },
    build: () => permissionHandlerCubit,
    act: (cubit) => cubit.requestPermission(locationPermission),
    expect: () => [
      const PermissionLoading(),
      const PermissionPermanentlyDenied(),
    ],
  );

  blocTest<PermissionHandlerCubit, PermissionHandlerState>(
    'emit PermissionRestricted '
    'when permissionHandler request is restricted',
    setUp: () {
      when(() => permissionHandler.requestPermission(locationPermission))
          .thenAnswer((_) async => PermissionStatus.restricted);
    },
    build: () => permissionHandlerCubit,
    act: (cubit) => cubit.requestPermission(locationPermission),
    expect: () => [
      const PermissionLoading(),
      const PermissionRestricted(),
    ],
  );

  blocTest<PermissionHandlerCubit, PermissionHandlerState>(
    'emit PermissionLimited '
    'when permissionHandler request is limited',
    setUp: () {
      when(() => permissionHandler.requestPermission(locationPermission))
          .thenAnswer((_) async => PermissionStatus.limited);
    },
    build: () => permissionHandlerCubit,
    act: (cubit) => cubit.requestPermission(locationPermission),
    expect: () => [
      const PermissionLoading(),
      const PermissionLimited(),
    ],
  );
}
