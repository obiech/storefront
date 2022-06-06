import 'package:flutter/material.dart';

abstract class IPrefsRepository {
  /// Preference helpers for user onboarding
  ///
  /// Check if user was onboarded
  Future<bool> isOnBoarded();

  /// Mark user as onbaorded
  Future<void> setIsOnBoarded(bool isOnBoarded);

  /// Preference helpers for [UserCredentialStorage]
  ///
  /// Includes setters, getters and clearers for session
  /// related information
  ///
  /// Get user's auth phone number
  Future<String?> userPhoneNumber();

  /// Set user's auth phone number
  Future<void> setUserPhoneNumber(String phoneNumber);

  /// Clear user's auth phone number
  Future<void> clearUserPhoneNumber();

  /// Get user's auth token
  Future<String?> userAuthToken();

  /// Get user's auth token
  Future<void> setUserAuthToken(String authToken);

  /// Clear user's auth token
  Future<void> clearUserAuthToken();

  /// Preference helpers for [DeviceFingerprintProvider]
  ///
  /// They are used to store fingerprint related information
  ///
  /// Retrive a user's finger print
  Future<String?> getFingerPrint();

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
  Future<Locale> getDeviceLocale();

  /// Clear Prefs
  Future<void> clear();
}
