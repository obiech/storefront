import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/utils/datetime.ext.dart';

void main() {
  group(
    'DateTime extension',
    () {
      final DateTime now = DateTime.now();

      final DateTime otherDate1 = now.add(
        const Duration(
          hours: 2,
          minutes: 10,
          seconds: 15,
        ),
      );

      final DateTime otherDate2 = now.add(
        const Duration(
          hours: 1,
          minutes: 55,
          seconds: 23,
        ),
      );

      group(
        '[getPrettyTimeDifference()]',
        () {
          test(
            'should format time difference string into hh:mm:ss '
            'given [TimeDiffFormat.hhmmss]',
            () {
              // act
              final String timeDiff1 = otherDate1.getPrettyTimeDifference(
                TimeDiffFormat.hhmmss,
                now,
              );

              final String timeDiff2 = otherDate2.getPrettyTimeDifference(
                TimeDiffFormat.hhmmss,
                now,
              );

              // assert
              expect(timeDiff1, '02:10:15');
              expect(timeDiff2, '01:55:23');
            },
          );

          test(
            'should format time difference string into mm:ss '
            'given [TimeDiffFormat.mmss]',
            () {
              // act
              final String timeDiff1 = otherDate1.getPrettyTimeDifference(
                TimeDiffFormat.mmss,
                now,
              );

              final String timeDiff2 = otherDate2.getPrettyTimeDifference(
                TimeDiffFormat.mmss,
                now,
              );

              // assert
              expect(timeDiff1, '10:15');
              expect(timeDiff2, '55:23');
            },
          );
        },
      );

      group('formatHm', () {
        final time1 = DateTime(2022, 05, 11, 13, 50);
        final time2 = DateTime(2022, 05, 11, 02, 09);

        test('should format time to HH:mm correctly', () {
          expect(time1.formatHm(), '13:50');
          expect(time2.formatHm(), '02:09');
        });
      });
    },
  );
}
