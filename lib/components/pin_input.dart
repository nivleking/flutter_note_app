import 'package:flutter/material.dart';
import 'package:flutter_note_app/models/pin.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinput/pinput.dart';

class PinInputBox extends StatelessWidget {
  final TextEditingController pinController;
  final bool isLogin;
  final bool isDelete;
  final Function(bool) onPinVerified;

  const PinInputBox({
    Key? key,
    required this.pinController,
    required this.isLogin,
    this.isDelete = false,
    required this.onPinVerified,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 16,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return Pinput(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: fillColor,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: focusedBorderColor),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyBorderWith(
        border: Border.all(color: Colors.redAccent),
      ),
      controller: pinController,
      autofocus: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      length: 6,
      onCompleted: (value) async {
        final pinIsValid = value == Hive.box<Pin>('pins').get('userPin')?.pin;
        await Future.delayed(const Duration(seconds: 1), () {
          if (isDelete) {
            onPinVerified(pinIsValid);
            if (pinIsValid) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PIN is successfully deleted!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop(true);
            }
          }
        });
      },
      validator: (s) {
        if (isLogin) {
          return s == Hive.box<Pin>('pins').get('userPin')?.pin
              ? null
              : 'Invalid PIN';
        } else {
          if (s!.length != 6) {
            return 'PIN must be 6 digits!';
          }
          return null;
        }
      },
      showCursor: true,
      obscureText: true,
    );
  }
}
