import 'package:bloc_test/bloc_test.dart';
import 'package:dropezy_proto/v1/order/order.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/cart_checkout/domain/utils/launch_go_pay.dart';
import 'package:storefront_app/features/order/index.dart';
import 'package:storefront_app/res/resources.dart';

class MockOrderRepository extends Mock implements IOrderRepository {}

class MockOrderHistoryCubit extends MockCubit<OrderHistoryState>
    implements OrderHistoryCubit {}

class MockBuildContext extends Mock implements BuildContext {}

class MockResources extends Mock implements Resources {}

class MockOrderServiceClient extends Mock implements OrderServiceClient {}

class MockGoPayLaunch extends Mock implements LaunchGoPay {}
