import 'package:firebase_auth/firebase_auth.dart';

/// Error Codes for [FirebaseAuthException] based on phone-specific errors and
/// other errors covered in Firebase docs at:
///
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithCredential.html
///
/// At the time of writing, [FirebaseAuth] v3.3.7 does use enums or constants for
/// their error codes so instead it's listed here for reference.
class FirebaseAuthExceptionCodes {
  /// Phone number format is invalid i.e. not starting with country calling code
  static const String invalidPhoneNumber = 'invalid-phone-number';

  /// Phone verification id is invalid i.e. the id sent in [codeSent] callback
  /// of [FirebaseAuth.verifyPhoneNumber] does not match
  static const String invalidPhoneVerificationId = 'invalid-verification-id';

  /// Invalid OTP
  static const String invalidPhoneVerificationCode =
      'invalid-verification-code';

  /// If credential is malformed or has expired
  static const String invalidCredential = 'invalid-credential';

  /// Thrown if there already exists an account with the given email address on
  /// other sign-in methods e.g. Facebook Login.
  ///
  /// Resolve this by calling [FirebaseAuth.fetchSignInMethodsForEmail]
  /// and then asking the user to sign in using one of the returned providers.
  static const String accountExistsWithDifferentCredential =
      'account-exists-with-different-credential';

  /// When chosen verification method is not enabled in Firebase Console
  static const String operationNotAllowed = 'operation-not-allowed';

  /// User account has been disabled
  static const String userDisabled = 'user-disabled';

  /// Used in email login; when user with given email is not found
  static const String userNotFound = 'user-not-found';

  /// Used in email login; when password is invalid for the given email,
  /// or if accont corresponding to the email does not have a password set.
  static const String wrongPassword = 'wrong-password';
}
