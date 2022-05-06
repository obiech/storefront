import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

import '../../../home/screens/home_page.dart';
import '../../blocs/blocs.dart';
import 'pin_input_field.dart';

part 'wrapper.dart';

class PinInputScreen extends StatefulWidget {
  const PinInputScreen({Key? key}) : super(key: key);

  static const routeName = '/pin-input';

  static const textInstructionsPin =
      'Buat kode PIN baru untuk\nmengamankan akunmu';
  static const textInstructionsConfirmPin =
      'Masukkan kembali kode PIN\n untuk konfirmasi';
  static const textErrorPinMismatch = 'PIN yang kamu masukkan tidak sesuai';

  static const keyInputPin = 'PinInputScreen_inputPin';
  static const keyInputConfirmPin = 'PinInputScreen_inputConfirmPin';
  static const keyLoadingIndicator = 'PinInputScreen_loadingIndicator';
  static const keyButtonSkip = 'PinInputScreen_buttonSkip';

  @override
  State<PinInputScreen> createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  late StreamController<ErrorAnimationType> _streamCtrlError;
  late TextEditingController _ctrlPin;
  late TextEditingController _ctrlConfirmPin;
  late FocusNode _focusNodePin;
  late FocusNode _focusNodeConfirmPin;

  bool firstInputFinished = false;
  bool pinMismatch = false;

  @override
  void initState() {
    super.initState();
    _streamCtrlError = StreamController<ErrorAnimationType>.broadcast();
    _ctrlPin = TextEditingController();
    _ctrlConfirmPin = TextEditingController();
    _focusNodePin = FocusNode();
    _focusNodeConfirmPin = FocusNode();
  }

  @override
  void dispose() {
    _streamCtrlError.close();
    _ctrlPin.dispose();
    _ctrlConfirmPin.dispose();
    _focusNodePin.dispose();
    _focusNodeConfirmPin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PinRegistrationCubit, PinRegistrationState>(
      listener: (context, state) {
        switch (state.status as PinRegistrationStatus) {
          case PinRegistrationStatus.success:
            _finishPinRegistrationProcess();
            break;
          case PinRegistrationStatus.error:
            showErrorBottomSheet(context, state.errMsg!);
            _resetState();
            break;
          default:
            break;
        }
      },
      child: DropezyScaffold.textTitle(
        title: 'PIN',
        useWhiteBody: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.res.dimens.pagePadding),
            child: TextButtonSkip(
              key: const Key(PinInputScreen.keyButtonSkip),
              onPressed: _finishPinRegistrationProcess,
            ),
          ),
        ],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AssetsPath.icLock,
                height: 42,
                width: 34,
              ),
              const SizedBox(height: 38),
              _textInstructions(),
              const SizedBox(height: 32),
              _pinInputFieldBuilder(),
              const SizedBox(height: 12),
              if (pinMismatch)
                Text(
                  PinInputScreen.textErrorPinMismatch,
                  style: DropezyTextStyles.caption2
                      .copyWith(color: DropezyColors.orange),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Marks onboarding process as finished, removes all previous routes
  /// and pushes [HomePage] route.
  ///
  /// Can be called without actually registering PIN, as it's optional
  Future<void> _finishPinRegistrationProcess() async {
    await getIt<IPrefsRepository>().setIsOnBoarded(true);
    context.router.replaceAll([
      const MainRoute(),
      const RequestLocationAccessRoute(),
    ]);
  }

  void _resetState() {
    setState(() {
      firstInputFinished = false;
    });
    _ctrlPin.text = '';
    _ctrlConfirmPin.text = '';
  }

  void _triggerErrorPinMismatch() {
    _resetState();
    setState(() {
      pinMismatch = true;
    });
    _streamCtrlError.add(ErrorAnimationType.shake);
    _focusNodePin.requestFocus();
  }

  Widget _textInstructions() => Text(
        !firstInputFinished
            ? PinInputScreen.textInstructionsPin
            : PinInputScreen.textInstructionsConfirmPin,
        style: DropezyTextStyles.subtitle.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      );

  Widget _pinInputFieldBuilder() =>
      BlocBuilder<PinRegistrationCubit, PinRegistrationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const CircularProgressIndicator(
              key: Key(PinInputScreen.keyLoadingIndicator),
            );
          }

          return Stack(
            children: [
              Offstage(
                offstage: firstInputFinished,
                child: SizedBox(
                  width: 216,
                  child: PinInputField(
                    key: const Key(PinInputScreen.keyInputPin),
                    controller: _ctrlPin,
                    focusNode: _focusNodePin,
                    errorAnimationController: _streamCtrlError,
                    onChanged: _onPinInputChanged,
                  ),
                ),
              ),
              Offstage(
                offstage: !firstInputFinished,
                child: SizedBox(
                  width: 216,
                  child: PinInputField(
                    key: const Key(PinInputScreen.keyInputConfirmPin),
                    controller: _ctrlConfirmPin,
                    focusNode: _focusNodeConfirmPin,
                    onChanged: _onConfirmPinInputChanged,
                  ),
                ),
              ),
            ],
          );
        },
      );

  void _onPinInputChanged(String str) {
    if (str.length < 6) {
      return;
    }

    firstInputFinished = true;
    _focusNodeConfirmPin.requestFocus();
    setState(() {});
  }

  void _onConfirmPinInputChanged(String str) {
    if (str.length < 6) {
      return;
    }

    // Ensure first and second input are the same
    if (_ctrlPin.text != str) {
      _triggerErrorPinMismatch();
      return;
    }

    setState(() {
      pinMismatch = false;
    });

    context.read<PinRegistrationCubit>().registerPin(str);
  }
}
