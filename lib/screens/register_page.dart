import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/components/pin_input.dart';
import 'package:flutter_note_app/models/pin.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinput/pinput.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final PinTheme defaultPinTheme;
  late final PinTheme focusedPinTheme;
  late final PinTheme submittedPinTheme;
  late final GlobalKey<FormState> formKey;
  late final FocusNode focusNode;
  late final TextEditingController pinController;
  late Box<Pin> pinBox;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();

    pinBox = Hive.box<Pin>('pins');
  }

  void registerPin(String pin) {
    pinBox.put(
      'userPin',
      Pin(pin: pin),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PIN is successfully created!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    // const borderColor = Color.fromRGBO(23, 171, 144, 0.4);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register New PIN',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Insert your newly 6-digit PIN',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              CupertinoIcons.lock,
              size: 50.0,
            ),
            Form(
              key: formKey,
              child: PinInputBox(
                pinController: pinController,
                isLogin: false,
              ),
            ),
            CupertinoButton(
              color: Colors.blue,
              child: Text(
                "Create",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                focusNode.unfocus();
                if (formKey.currentState!.validate()) {
                  registerPin(pinController.text);
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid PIN!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
