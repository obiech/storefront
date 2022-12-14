import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:places_service/places_service.dart';
import 'package:storefront_app/core/core.dart';

part 'exception_to_failure.ext.dart';
part 'network_failures.dart';

/// [Failure] represents an error that has been handled gracefully
class Failure {
  final String message;

  Failure(this.message);
}
