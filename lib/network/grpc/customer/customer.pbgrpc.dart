///
//  Generated code. Do not modify.
//  source: v1/customer/customer.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'customer.pb.dart' as $1;
export 'customer.pb.dart';

class CustomerServiceClient extends $grpc.Client {
  static final _$check = $grpc.ClientMethod<$1.CheckRequest, $1.CheckResponse>(
      '/dropezy.v1.customer.CustomerService/Check',
      ($1.CheckRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.CheckResponse.fromBuffer(value));
  static final _$register =
      $grpc.ClientMethod<$1.RegisterRequest, $1.RegisterResponse>(
          '/dropezy.v1.customer.CustomerService/Register',
          ($1.RegisterRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.RegisterResponse.fromBuffer(value));
  static final _$savePIN =
      $grpc.ClientMethod<$1.SavePINRequest, $1.SavePINResponse>(
          '/dropezy.v1.customer.CustomerService/SavePIN',
          ($1.SavePINRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.SavePINResponse.fromBuffer(value));
  static final _$authorize =
      $grpc.ClientMethod<$1.AuthorizeRequest, $1.AuthorizeResponse>(
          '/dropezy.v1.customer.CustomerService/Authorize',
          ($1.AuthorizeRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $1.AuthorizeResponse.fromBuffer(value));

  CustomerServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$1.CheckResponse> check($1.CheckRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$check, request, options: options);
  }

  $grpc.ResponseFuture<$1.RegisterResponse> register($1.RegisterRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$register, request, options: options);
  }

  $grpc.ResponseFuture<$1.SavePINResponse> savePIN($1.SavePINRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$savePIN, request, options: options);
  }

  $grpc.ResponseFuture<$1.AuthorizeResponse> authorize(
      $1.AuthorizeRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$authorize, request, options: options);
  }
}

abstract class CustomerServiceBase extends $grpc.Service {
  $core.String get $name => 'dropezy.v1.customer.CustomerService';

  CustomerServiceBase() {
    $addMethod($grpc.ServiceMethod<$1.CheckRequest, $1.CheckResponse>(
        'Check',
        check_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.CheckRequest.fromBuffer(value),
        ($1.CheckResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.RegisterRequest, $1.RegisterResponse>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.RegisterRequest.fromBuffer(value),
        ($1.RegisterResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.SavePINRequest, $1.SavePINResponse>(
        'SavePIN',
        savePIN_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.SavePINRequest.fromBuffer(value),
        ($1.SavePINResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.AuthorizeRequest, $1.AuthorizeResponse>(
        'Authorize',
        authorize_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.AuthorizeRequest.fromBuffer(value),
        ($1.AuthorizeResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.CheckResponse> check_Pre(
      $grpc.ServiceCall call, $async.Future<$1.CheckRequest> request) async {
    return check(call, await request);
  }

  $async.Future<$1.RegisterResponse> register_Pre(
      $grpc.ServiceCall call, $async.Future<$1.RegisterRequest> request) async {
    return register(call, await request);
  }

  $async.Future<$1.SavePINResponse> savePIN_Pre(
      $grpc.ServiceCall call, $async.Future<$1.SavePINRequest> request) async {
    return savePIN(call, await request);
  }

  $async.Future<$1.AuthorizeResponse> authorize_Pre($grpc.ServiceCall call,
      $async.Future<$1.AuthorizeRequest> request) async {
    return authorize(call, await request);
  }

  $async.Future<$1.CheckResponse> check(
      $grpc.ServiceCall call, $1.CheckRequest request);
  $async.Future<$1.RegisterResponse> register(
      $grpc.ServiceCall call, $1.RegisterRequest request);
  $async.Future<$1.SavePINResponse> savePIN(
      $grpc.ServiceCall call, $1.SavePINRequest request);
  $async.Future<$1.AuthorizeResponse> authorize(
      $grpc.ServiceCall call, $1.AuthorizeRequest request);
}
