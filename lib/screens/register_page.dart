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
        content: Text(
          'PIN is successfully created!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
    Brightness theme = MediaQuery.of(context).platformBrightness;
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(8.0),
          child: Divider(
            height: 0.8,
            thickness: 0.3,
            color: theme == Brightness.light
                ? Colors.grey[300]
                : Colors.grey[700]!,
          ),
        ),
        backgroundColor:
            theme == Brightness.light ? Colors.white : Colors.grey[800]!,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Insert your newly 6-digit PIN',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 81.0),
            const Icon(
              CupertinoIcons.lock,
              size: 50.0,
            ),
            const SizedBox(height: 81.0),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: PinInputBox(
                  pinController: pinController,
                  isLogin: false,
                  onPinVerified: (p0) {},
                ),
              ),
            ),
            const SizedBox(height: 81.0),
            CupertinoButton(
              color: Colors.blue,
              child: Text(
                "Create",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                      content: Text(
                        'Invalid PIN!',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
