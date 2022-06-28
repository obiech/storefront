import 'package:flutter/material.dart';
import 'package:storefront_app/core/services/geofence/models/darkstore_metadata.dart';

abstract class IPrefsRepository {
  /// Preference helpers for [UserCredentialStorage]
  ///
  /// Includes setters, getters and clearers for session
  /// related information
  ///
  /// Get user's auth phone number
  String? userPhoneNumber();

  /// Set user's auth phone number
  Future<void> setUserPhoneNumber(String phoneNumber);

  /// Clear user's auth phone number
  Future<void> clearUserPhoneNumber();

  /// Get user's auth token
  String? userAuthToken();

  /// Get user's auth token
  Future<void> setUserAuthToken(String authToken);

  /// Clear user's auth token
  Future<void> clearUserAuthToken();

  /// Preference helpers for [DeviceFingerprintProvider]
  ///
  /// They are used to store fingerprint related information
  ///
  /// Retrieve a user's finger print
  String? getFingerPrint();
  
  /// Preference helpers to retrieve stored [DarkStoreMetadata] 
  DarkStoresMetadata? getMetaData();
  
  /// Preference helpers to delete stored [DarkStoreMetadata] 
  Future<void> deleteMetaData();
  
  /// Preference helpers to set stored [DarkStoreMetadata] 
  Future<void> setMetaData(DarkStoresMetadata metaData);

  /// This is used to check if fingerPrint is saved.
  bool isDeviceFingerPrintCached();

  /// Store user's finger print
  Future<void> setFingerPrint(String fingerPrint);

  /// Locale preferences
  ///
  /// Set device locale, takes [Locale] and
  /// stores it's id in preferences
  Future<void> setDeviceLocale(Locale locale);

  /// Get device Locale
  ///
  /// Returns [Locale] with indonesian being the default
  Locale getDeviceLocale();

  /// Clear Prefs
  Future<void> clear();
}
