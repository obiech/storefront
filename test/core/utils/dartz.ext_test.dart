import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';

void main() {
  final leftObj = Failure('error');
  const rightObj = 'success';

  group(
    '[EitherTestX]',
    () {
      test(
        '[getLeft()] should return value of [Left] '
        'when Either is a [Left]',
        () {
          final Either<Failure, Object> either = left(leftObj);
          expect(either.getLeft(), leftObj);
        },
      );

      test(
        '[getLeft()] should throw a [NotLeftError] '
        'when Either is a [Right]',
        () {
          final Either<Failure, Object> either = right(rightObj);

          expect(
            () => either.getLeft(),
            throwsA(isA<NotLeftError>()),
          );
        },
      );

      test(
        '[getRight()] should return value of [Right] '
        'when Either is a [Right]',
        () {
          final Either<Failure, Object> either = right(rightObj);
          expect(either.getRight(), rightObj);
        },
      );

      test(
        '[getRight()] should throw a [NotRightError] '
        'when Either is a [Right]',
        () {
          final Either<Failure, Object> either = left(leftObj);

          expect(
            () => either.getRight(),
            throwsA(isA<NotRightError>()),
          );
        },
      );
    },
  );
}
