import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/address/index.dart';

class MockDeliveryAddressRepository extends Mock
    implements IDeliveryAddressRepository {}

class MockDeliveryAddressCubit extends MockCubit<DeliveryAddressState>
    implements DeliveryAddressCubit {}
