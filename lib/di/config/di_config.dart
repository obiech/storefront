import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:storefront_app/core/core.dart';

class DiConfig {
  static final enableDummyRepos = dotenv.getBool(
    'ENABLE_DUMMY_REPOS',
    fallback: true,
  );
}
