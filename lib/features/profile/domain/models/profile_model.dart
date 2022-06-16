import 'package:dropezy_proto/v1/customer/customer.pb.dart';
import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  const ProfileModel({
    required this.fullName,
    required this.phoneNumber,
  });

  /// User assigned name
  final String fullName;

  /// user registered phone number
  final String phoneNumber;

  factory ProfileModel.fromPb(Profile profile) {
    return ProfileModel(
      fullName: profile.fullName,
      phoneNumber: profile.phoneNumber,
    );
  }
  ProfileModel copyWith({String? fullName, String? phoneNumber}) {
    return ProfileModel(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [fullName, phoneNumber];
}
