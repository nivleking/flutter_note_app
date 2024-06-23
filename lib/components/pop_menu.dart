import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/components/pin_input.dart';
import 'package:flutter_note_app/models/pin.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomPopMenu extends StatefulWidget {
  const CustomPopMenu({super.key});

  @override
  State<CustomPopMenu> createState() => _CustomPopMenuState();
}

class _CustomPopMenuState extends State<CustomPopMenu> {
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Icon(Icons.logout),
      onSelected: (value) async {
        if (value == 'logout') {
          Navigator.pushReplacementNamed(context, '/login');
        }
        if (value == 'del_pin') {
          final pinController = TextEditingController();
          final bool pinConfirmed = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm PIN'),
                    alignment: Alignment.center,
                    content: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: 300, maxHeight: 100),
                      child: Form(
                        key: formKey,
                        child: PinInputBox(
                          pinController: pinController,
                          isLogin: true,
                          isDelete: true,
                          onPinVerified: (bool verified) {
                            Navigator.of(context).pop(verified);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ) ??
              false;

          if (pinConfirmed) {
            Hive.box<Pin>('pins').delete('userPin');
            Future.delayed(Duration.zero, () {
              Navigator.pushNamed(context, '/register');
            });
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'del_pin',
          child: Text(
            'Delete PIN and Logout',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
