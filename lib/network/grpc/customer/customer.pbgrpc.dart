///
//  Generated code. Do not modify.
//  source: v1/customer/customer.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'customer.pb.dart' as $0;
export 'customer.pb.dart';

class CustomerServiceClient extends $grpc.Client {
  static final _$check = $grpc.ClientMethod<$0.CheckRequest, $0.CheckResponse>(
      '/dropezy.v1.proto.CustomerService/Check',
      ($0.CheckRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.CheckResponse.fromBuffer(value));
  static final _$register =
      $grpc.ClientMethod<$0.RegisterRequest, $0.RegisterResponse>(
          '/dropezy.v1.proto.CustomerService/Register',
          ($0.RegisterRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.RegisterResponse.fromBuffer(value));
  static final _$savePIN =
      $grpc.ClientMethod<$0.SavePINRequest, $0.SavePINResponse>(
          '/dropezy.v1.proto.CustomerService/SavePIN',
          ($0.SavePINRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.SavePINResponse.fromBuffer(value));
  static final _$authorize =
      $grpc.ClientMethod<$0.AuthorizeRequest, $0.AuthorizeResponse>(
          '/dropezy.v1.proto.CustomerService/Authorize',
          ($0.AuthorizeRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.AuthorizeResponse.fromBuffer(value));

  CustomerServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.CheckResponse> check($0.CheckRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$check, request, options: options);
  }

  $grpc.ResponseFuture<$0.RegisterResponse> register($0.RegisterRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$register, request, options: options);
  }

  $grpc.ResponseFuture<$0.SavePINResponse> savePIN($0.SavePINRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$savePIN, request, options: options);
  }

  $grpc.ResponseFuture<$0.AuthorizeResponse> authorize(
      $0.AuthorizeRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$authorize, request, options: options);
  }
}

abstract class CustomerServiceBase extends $grpc.Service {
  $core.String get $name => 'dropezy.v1.proto.CustomerService';

  CustomerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CheckRequest, $0.CheckResponse>(
        'Check',
        check_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CheckRequest.fromBuffer(value),
        ($0.CheckResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $0.RegisterResponse>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($0.RegisterResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SavePINRequest, $0.SavePINResponse>(
        'SavePIN',
        savePIN_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SavePINRequest.fromBuffer(value),
        ($0.SavePINResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AuthorizeRequest, $0.AuthorizeResponse>(
        'Authorize',
        authorize_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AuthorizeRequest.fromBuffer(value),
        ($0.AuthorizeResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CheckResponse> check_Pre(
      $grpc.ServiceCall call, $async.Future<$0.CheckRequest> request) async {
    return check(call, await request);
  }

  $async.Future<$0.RegisterResponse> register_Pre(
      $grpc.ServiceCall call, $async.Future<$0.RegisterRequest> request) async {
    return register(call, await request);
  }

  $async.Future<$0.SavePINResponse> savePIN_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SavePINRequest> request) async {
    return savePIN(call, await request);
  }

  $async.Future<$0.AuthorizeResponse> authorize_Pre($grpc.ServiceCall call,
      $async.Future<$0.AuthorizeRequest> request) async {
    return authorize(call, await request);
  }

  $async.Future<$0.CheckResponse> check(
      $grpc.ServiceCall call, $0.CheckRequest request);
  $async.Future<$0.RegisterResponse> register(
      $grpc.ServiceCall call, $0.RegisterRequest request);
  $async.Future<$0.SavePINResponse> savePIN(
      $grpc.ServiceCall call, $0.SavePINRequest request);
  $async.Future<$0.AuthorizeResponse> authorize(
      $grpc.ServiceCall call, $0.AuthorizeRequest request);
}
