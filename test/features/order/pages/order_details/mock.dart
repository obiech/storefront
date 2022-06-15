import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/order/index.dart';

class MockOrderDetailsCubit extends MockCubit<OrderDetailsState>
    implements OrderDetailsCubit {}

class MockIOrderRepository extends Mock implements IOrderRepository {}
