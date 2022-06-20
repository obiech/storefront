import 'package:bloc_test/bloc_test.dart';
import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

class MockSearchLocationBloc
    extends MockBloc<SearchLocationEvent, SearchLocationState>
    implements SearchLocationBloc {}

class MockDateTimeProvider extends Mock implements DateTimeProvider {}

class MockCustomerServiceClient extends Mock implements CustomerServiceClient {}

class MockDropezyPlacesService extends Mock implements DropezyPlacesService {}

class MockSearchLocationRespository extends Mock
    implements ISearchLocationRepository {}

class MockSearchLocationHistoryRepository extends Mock
    implements ISearchLocationHistoryRepository {}

class MockSearchLocationHistoryBloc
    extends MockBloc<SearchLocationHistoryEvent, SearchLocationHistoryState>
    implements SearchLocationHistoryBloc {}

class MockSearchHistoryBox extends Mock
    implements Box<SearchLocationHistoryQuery> {}

class MockDropezyGeolocator extends Mock implements DropezyGeolocator {}
