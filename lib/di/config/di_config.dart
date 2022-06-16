import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:storefront_app/core/core.dart';

/// For configuration related to dependency injection framework
class DiConfig {
  static final enableDummyRepos = dotenv.getBool(
    'ENABLE_DUMMY_REPOS',
    fallback: true,
  );

  static final enableFirebaseAuth = dotenv.getBool(
    'ENABLE_FIREBASE_AUTH',
    fallback: true,
  );
}
