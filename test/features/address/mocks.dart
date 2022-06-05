import 'package:bloc_test/bloc_test.dart';
import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';
import 'package:storefront_app/features/permission_handler/index.dart';

class MockDeliveryAddressRepository extends Mock
    implements IDeliveryAddressRepository {}

class MockDeliveryAddressCubit extends MockCubit<DeliveryAddressState>
    implements DeliveryAddressCubit {}

class MockAddressDetailBloc
    extends MockBloc<AddressDetailEvent, AddressDetailState>
    implements AddressDetailBloc {}

class MockPermissionHandlerCubit extends MockCubit<PermissionHandlerState>
    implements PermissionHandlerCubit {}

class MockDateTimeProvider extends Mock implements DateTimeProvider {}

class MockCustomerServiceClient extends Mock implements CustomerServiceClient {}
