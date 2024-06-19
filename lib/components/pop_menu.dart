import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/models/pin.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomPopMenu extends StatelessWidget {
  const CustomPopMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Icon(CupertinoIcons.gear),
      onSelected: (value) {
        if (value == 'logout') {
          Navigator.pushReplacementNamed(context, '/login');
        }
        if (value == 'del_pin') {
          Hive.box<Pin>('pins').delete('userPin');
          Navigator.pushReplacementNamed(context, '/register');
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
