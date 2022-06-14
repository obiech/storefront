import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/index.dart';

import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  group(
    '[CustomerService]',
    () {
      const mockPhoneNumber = '+6281234567890';
      const mockFullName = 'dummyName';

      late CustomerServiceClient customerServiceClient;
      late CustomerService customerService;

      setUp(() {
        customerServiceClient = MockCustomerServiceClient();
        customerService = CustomerService(customerServiceClient);
      });

      group(
        '[registerPhoneNumber()]',
        () {
          final mockRequest = RegisterRequest(phoneNumber: mockPhoneNumber);
          test(
            'should call [CustomerServiceClient.register] once '
            'and return Unit '
            'when request is successful',
            () async {
              when(
                () => customerServiceClient.register(mockRequest),
              ).thenAnswer(
                (_) => MockResponseFuture.value(RegisterResponse()),
              );

              final result =
                  await customerService.registerPhoneNumber(mockPhoneNumber);

              final unit = result.getRight();
              expect(unit, isA<Unit>());

              verify(() => customerServiceClient.register(mockRequest))
                  .called(1);
            },
          );

          test(
            'should call [CustomerServiceClient.register] once '
            'and return a Failure '
            'when request is not successful',
            () async {
              when(
                () => customerServiceClient
                    .register(RegisterRequest(phoneNumber: mockPhoneNumber)),
              ).thenAnswer(
                (_) => MockResponseFuture.error(GrpcError.internal('Error')),
              );

              final result =
                  await customerService.registerPhoneNumber(mockPhoneNumber);

              final failure = result.getLeft();
              expect(failure, isA<NetworkFailure>());
              expect(failure.message, 'Error');

              verify(() => customerServiceClient.register(mockRequest))
                  .called(1);
            },
          );
        },
      );

      group('[updateFullName()]', () {
        final mockRequest = UpdateProfileRequest(
          profile: Profile(fullName: mockFullName),
        );

        test(
          'should call [CustomerServiceClient.updateProfile] once '
          'and return Unit '
          'when request is successful',
          () async {
            when(
              () => customerServiceClient.updateProfile(mockRequest),
            ).thenAnswer(
              (_) => MockResponseFuture.value(UpdateProfileResponse()),
            );

            final result = await customerService.updateFullName(mockFullName);

            final unit = result.getRight();
            expect(unit, isA<Unit>());

            verify(() => customerServiceClient.updateProfile(mockRequest))
                .called(1);
          },
        );

        test(
          'should call [CustomerServiceClient.updateProfile] once '
          'and return a Failure '
          'when request is not successful',
          () async {
            when(
              () => customerServiceClient.updateProfile(mockRequest),
            ).thenAnswer(
              (_) => MockResponseFuture.error(GrpcError.internal('Error')),
            );

            final result = await customerService.updateFullName(mockFullName);

            final failure = result.getLeft();
            expect(failure, isA<NetworkFailure>());
            expect(failure.message, 'Error');

            verify(() => customerServiceClient.updateProfile(mockRequest))
                .called(1);
          },
        );
      });
    },
  );
}
