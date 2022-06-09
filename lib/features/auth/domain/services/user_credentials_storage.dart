import 'dart:async';

import 'package:flutter/material.dart';

import '../repository/user_credentials.dart';

/// Single source of truth for obtaining [UserCredentials] stored on device.
abstract class UserCredentialsStorage {
  final _streamController = StreamController<UserCredentials?>.broadcast();

  Stream<UserCredentials?> get stream => _streamController.stream;

  @protected
  @visibleForTesting
  void addToStream(UserCredentials? creds) {
    _streamController.add(creds);
  }

  /// Get currently stored [UserCredentials]. Returns [null] if not found.
  UserCredentials? getCredentials();

  /// Persist [UserCredentials] into storage.
  Future<void> persistCredentials(String authToken, String phoneNumber);

  /// Remove [UserCredentials] from storage.
  Future<void> unpersistCredentials();

  /// Remove [UserCredentials] from storage and clear prefs
  Future<void> signOutApps();
}
