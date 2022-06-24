import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/shared_widgets/time/countdown_builder.dart';

void main() {
  testWidgets(
    'CountdownBuilder should rebuild widget every second '
    'and stop upon reaching 0 seconds ',
    (tester) async {
      const testDurationInSeconds = 10;

      await tester.pumpWidget(
        MaterialApp(
          home: CountdownBuilder(
            countdownDuration: testDurationInSeconds,
            builder: (time) {
              return Text(time.toString());
            },
          ),
        ),
      );

      final state = tester.state<CountdownBuilderState>(
        find.byType(CountdownBuilder),
      );

      // should tick every second
      for (int i = testDurationInSeconds; i > 0; i--) {
        expect(state.timeLeftInSeconds, i);
        expect(find.text(state.timeLeftInSeconds.toString()), findsOneWidget);

        await tester.pump(const Duration(seconds: 1));
      }

      // should stop ticking
      expect(state.timeLeftInSeconds, 0);
      await tester.pump(const Duration(seconds: 60));
      expect(state.timeLeftInSeconds, 0);
    },
  );

  testWidgets(
    'CountdownBuilder should convert negative values into 0 '
    'and not start countdown',
    (tester) async {
      const testDurationInSeconds = -10;

      await tester.pumpWidget(
        MaterialApp(
          home: CountdownBuilder(
            countdownDuration: testDurationInSeconds,
            builder: (time) {
              return Text(time.toString());
            },
          ),
        ),
      );

      final state = tester.state<CountdownBuilderState>(
        find.byType(CountdownBuilder),
      );

      expect(state.timeLeftInSeconds, 0);

      // should not continue ticking
      for (int i = 0; i < 10; i++) {
        expect(state.timeLeftInSeconds, 0);
        expect(find.text('0'), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
      }

      expect(state.timeLeftInSeconds, 0);
      expect(state.timer, null);
      expect(find.text('0'), findsOneWidget);
    },
  );
}
