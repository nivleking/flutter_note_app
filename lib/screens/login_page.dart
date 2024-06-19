import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/components/pin_input.dart';
import 'package:flutter_note_app/models/pin.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinput/pinput.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input PIN',
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
              'Insert the 6-digit PIN',
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
                isLogin: true,
              ),
            ),
            CupertinoButton(
              color: Colors.blue,
              child: Text(
                "Validate",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                focusNode.unfocus();
                if (formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PIN is correct!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushReplacementNamed(context, '/home');
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
