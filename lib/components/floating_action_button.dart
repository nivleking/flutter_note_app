import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        CupertinoIcons.add,
        color: Colors.white,
      ),
      backgroundColor: Colors.blue,
      onPressed: () {
        // _showAddNoteBottomSheet(context);
        Navigator.pushNamed(
          context,
          '/note',
          arguments: {
            'mode': 'add',
            'uuid': '',
          },
        );
      },
    );
  }
}
