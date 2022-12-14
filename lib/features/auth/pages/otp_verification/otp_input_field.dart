part of 'otp_verification_page.dart';

class OtpInputField extends StatefulWidget {
  static const keyInputField = 'OtpInputField_textField';
  static const keyErrorMessage = 'OtpInputFied_errorMsg';

  const OtpInputField({Key? key}) : super(key: key);

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late StreamController<ErrorAnimationType> _streamCtrlError;
  late TextEditingController _ctrlOtp;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _streamCtrlError = StreamController<ErrorAnimationType>();
    _ctrlOtp = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _streamCtrlError.close();
    _ctrlOtp.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountVerificationCubit, AccountVerificationState>(
      listenWhen: (previous, current) =>
          current is AccountVerificationInvalidOtp,
      listener: (_, state) {
        _triggerErrorOtpIsInvalid();
      },
      builder: (_, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: PinCodeTextField(
                key: const Key(OtpInputField.keyInputField),
                enabled: state is! AccountVerificationLoading &&
                    state is! AccountVerificationInitial,
                controller: _ctrlOtp,
                autoDisposeControllers: false,
                appContext: context,
                pinTheme: defaultPinTheme,
                keyboardType: TextInputType.number,
                length: 6,
                focusNode: _focusNode,

                /// causes pumpAndSettle in Widget Test to time out
                /// if set to true
                showCursor: !kTestMode,
                cursorHeight: 20,
                textStyle: DropezyTextStyles.textOtp,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                useHapticFeedback: true,
                autoFocus: true,
                enableActiveFill: true,
                errorAnimationController: _streamCtrlError,
                errorAnimationDuration: 200,
                onChanged: (str) {
                  if (str.length == 6) {
                    context.read<AccountVerificationCubit>().verifyOtp(str);
                  }
                },
              ),
            ),
            if (state is AccountVerificationInvalidOtp) ...[
              const SizedBox(height: 12),
              Text(
                'Kode OTP yang kamu masukkan salah',
                key: const Key(OtpInputField.keyErrorMessage),
                style: DropezyTextStyles.caption2
                    .copyWith(color: DropezyColors.orange),
              )
            ]
          ],
        );
      },
    );
  }

  void _triggerErrorOtpIsInvalid() {
    _streamCtrlError.add(ErrorAnimationType.shake);
    _ctrlOtp.text = '';
    _focusNode.requestFocus();
  }

  PinTheme get defaultPinTheme => PinTheme(
        activeColor: DropezyColors.blue,
        selectedColor: DropezyColors.blue,
        activeFillColor: DropezyColors.lightBlue,
        selectedFillColor: DropezyColors.lightBlue,
        inactiveFillColor: DropezyColors.lightBlue,
        borderWidth: 1,
        inactiveColor: Colors.transparent,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: 56,
        fieldWidth: 48,
        errorBorderColor: DropezyColors.orange,
      );
}
