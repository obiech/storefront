///
//  Generated code. Do not modify.
//  source: v1/customer/customer.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package, constant_identifier_names

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use profileDescriptor instead')
const Profile$json = const {
  '1': 'Profile',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'phone_number', '3': 2, '4': 1, '5': 9, '10': 'phoneNumber'},
    const {
      '1': 'devices',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.dropezy.v1.proto.Device',
      '10': 'devices'
    },
  ],
};

/// Descriptor for `Profile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileDescriptor = $convert.base64Decode(
    'CgdQcm9maWxlEg4KAmlkGAEgASgJUgJpZBIhCgxwaG9uZV9udW1iZXIYAiABKAlSC3Bob25lTnVtYmVyEjIKB2RldmljZXMYAyADKAsyGC5kcm9wZXp5LnYxLnByb3RvLkRldmljZVIHZGV2aWNlcw==');
@$core.Deprecated('Use deviceDescriptor instead')
const Device$json = const {
  '1': 'Device',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'fingerprint', '3': 2, '4': 1, '5': 9, '10': 'fingerprint'},
    const {'1': 'pin', '3': 3, '4': 1, '5': 9, '10': 'pin'},
  ],
};

/// Descriptor for `Device`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceDescriptor = $convert.base64Decode(
    'CgZEZXZpY2USEgoEbmFtZRgBIAEoCVIEbmFtZRIgCgtmaW5nZXJwcmludBgCIAEoCVILZmluZ2VycHJpbnQSEAoDcGluGAMgASgJUgNwaW4=');
@$core.Deprecated('Use checkRequestDescriptor instead')
const CheckRequest$json = const {
  '1': 'CheckRequest',
  '2': const [
    const {'1': 'phone_number', '3': 1, '4': 1, '5': 9, '10': 'phoneNumber'},
  ],
};

/// Descriptor for `CheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkRequestDescriptor = $convert.base64Decode(
    'CgxDaGVja1JlcXVlc3QSIQoMcGhvbmVfbnVtYmVyGAEgASgJUgtwaG9uZU51bWJlcg==');
@$core.Deprecated('Use checkResponseDescriptor instead')
const CheckResponse$json = const {
  '1': 'CheckResponse',
  '2': const [
    const {
      '1': 'profile',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.dropezy.v1.proto.Profile',
      '10': 'profile'
    },
  ],
};

/// Descriptor for `CheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkResponseDescriptor = $convert.base64Decode(
    'Cg1DaGVja1Jlc3BvbnNlEjMKB3Byb2ZpbGUYASABKAsyGS5kcm9wZXp5LnYxLnByb3RvLlByb2ZpbGVSB3Byb2ZpbGU=');
@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = const {
  '1': 'RegisterRequest',
  '2': const [
    const {'1': 'phone_number', '3': 1, '4': 1, '5': 9, '10': 'phoneNumber'},
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert.base64Decode(
    'Cg9SZWdpc3RlclJlcXVlc3QSIQoMcGhvbmVfbnVtYmVyGAEgASgJUgtwaG9uZU51bWJlcg==');
@$core.Deprecated('Use registerResponseDescriptor instead')
const RegisterResponse$json = const {
  '1': 'RegisterResponse',
  '2': const [
    const {
      '1': 'profile',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.dropezy.v1.proto.Profile',
      '10': 'profile'
    },
  ],
};

/// Descriptor for `RegisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerResponseDescriptor = $convert.base64Decode(
    'ChBSZWdpc3RlclJlc3BvbnNlEjMKB3Byb2ZpbGUYASABKAsyGS5kcm9wZXp5LnYxLnByb3RvLlByb2ZpbGVSB3Byb2ZpbGU=');
@$core.Deprecated('Use savePINRequestDescriptor instead')
const SavePINRequest$json = const {
  '1': 'SavePINRequest',
  '2': const [
    const {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.dropezy.v1.proto.Device',
      '10': 'device'
    },
  ],
};

/// Descriptor for `SavePINRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savePINRequestDescriptor = $convert.base64Decode(
    'Cg5TYXZlUElOUmVxdWVzdBIwCgZkZXZpY2UYASABKAsyGC5kcm9wZXp5LnYxLnByb3RvLkRldmljZVIGZGV2aWNl');
@$core.Deprecated('Use savePINResponseDescriptor instead')
const SavePINResponse$json = const {
  '1': 'SavePINResponse',
  '2': const [
    const {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.dropezy.v1.proto.Device',
      '10': 'device'
    },
  ],
};

/// Descriptor for `SavePINResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savePINResponseDescriptor = $convert.base64Decode(
    'Cg9TYXZlUElOUmVzcG9uc2USMAoGZGV2aWNlGAEgASgLMhguZHJvcGV6eS52MS5wcm90by5EZXZpY2VSBmRldmljZQ==');
@$core.Deprecated('Use authorizeRequestDescriptor instead')
const AuthorizeRequest$json = const {
  '1': 'AuthorizeRequest',
  '2': const [
    const {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.dropezy.v1.proto.Device',
      '10': 'device'
    },
  ],
};

/// Descriptor for `AuthorizeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorizeRequestDescriptor = $convert.base64Decode(
    'ChBBdXRob3JpemVSZXF1ZXN0EjAKBmRldmljZRgBIAEoCzIYLmRyb3BlenkudjEucHJvdG8uRGV2aWNlUgZkZXZpY2U=');
@$core.Deprecated('Use authorizeResponseDescriptor instead')
const AuthorizeResponse$json = const {
  '1': 'AuthorizeResponse',
  '2': const [
    const {'1': 'authorized', '3': 1, '4': 1, '5': 8, '10': 'authorized'},
  ],
};

/// Descriptor for `AuthorizeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorizeResponseDescriptor = $convert.base64Decode(
    'ChFBdXRob3JpemVSZXNwb25zZRIeCgphdXRob3JpemVkGAEgASgIUgphdXRob3JpemVk');
