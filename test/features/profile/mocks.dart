import 'package:bloc_test/bloc_test.dart';
import 'package:storefront_app/features/profile/index.dart';

class MockProfileCubit extends MockCubit<ProfileState> implements ProfileCubit {
}

class MockEditProfileBloc extends MockBloc<EditProfileEvent, EditProfileState>
    implements EditProfileBloc {}
