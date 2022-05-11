import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/utils/dotenv.ext.dart';

void main() {
  group(
    '[DotEnvX]',
    () {
      group(
        '[getBool()]',
        () {
          test(
            "should return true for string 'true' case insensitive "
            'and ignores whitespace',
            () {
              dotenv.testLoad(
                fileInput: '''
                ONE=true
                TWO=tRuE
                THREE=TRUE\t
                ''',
              );

              expect(dotenv.getBool('ONE'), true);
              expect(dotenv.getBool('TWO'), true);
              expect(dotenv.getBool('THREE'), true);
            },
          );

          test(
            'should return false for all other strings',
            () {
              dotenv.testLoad(
                fileInput: '''
                ONE=false
                ''',
              );

              expect(dotenv.getBool('ONE'), false);
            },
          );

          test(
            'should return fallback value for missing key '
            'and throw MissingEnvError if no fallback is provided',
            () {
              dotenv.testLoad(
                fileInput: '''
                ONE=false
                ''',
              );

              expect(dotenv.getBool('TWO', fallback: false), false);
              expect(
                () => dotenv.getBool('THREE'),
                throwsA(isA<MissingEnvError>()),
              );
            },
          );
        },
      );

      group(
        '[getString()]',
        () {
          setUp(() {
            dotenv.testLoad(
              fileInput: '''
                ONE=foobar
                ''',
            );
          });

          test('should return String value as specified in .env file', () {
            expect(dotenv.getString('ONE'), 'foobar');
          });

          test(
            'should return fallback value for missing key '
            'and throw MissingEnvError if no fallback is provided',
            () {
              expect(dotenv.getString('TWO', fallback: 'fallback'), 'fallback');
              expect(
                () => dotenv.getString('THREE'),
                throwsA(isA<MissingEnvError>()),
              );
            },
          );
        },
      );

      group(
        '[getInt()]',
        () {
          setUp(() {
            dotenv.testLoad(
              fileInput: '''
                ONE=123
                ''',
            );
          });

          test(
            'should return int value as specified in .env file',
            () {
              expect(dotenv.getInt('ONE'), 123);
            },
          );

          test(
            'should return fallback value for missing key '
            'and throw MissingEnvError if no fallback is provided',
            () {
              expect(dotenv.getInt('TWO', fallback: 1000), 1000);
              expect(
                () => dotenv.getInt('THREE'),
                throwsA(isA<MissingEnvError>()),
              );
            },
          );
        },
      );

      group(
        '[getDouble()]',
        () {
          setUp(() {
            dotenv.testLoad(
              fileInput: '''
                ONE=22.11
                ''',
            );
          });

          test(
            'should return double value as specified in .env file',
            () {
              expect(dotenv.getDouble('ONE'), 22.11);
            },
          );

          test(
            'should return fallback value for missing key '
            'and throw MissingEnvError if no fallback is provided',
            () {
              expect(dotenv.getDouble('TWO', fallback: 33.33), 33.33);
              expect(
                () => dotenv.getDouble('THREE'),
                throwsA(isA<MissingEnvError>()),
              );
            },
          );
        },
      );
    },
  );
}
