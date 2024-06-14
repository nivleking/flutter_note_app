import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  final String mode;
  NotePage({
    super.key,
    required this.mode,
  });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  void showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: GridView.count(
            crossAxisCount: 5,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: Colors.accents.map((Color color) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, color);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    color: color,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    ).then((selectedColor) {
      if (selectedColor != null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.mode == 'add' ? 'Add Note' : 'Edit Note',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.trash,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {
              showColorPicker();
            },
            icon: Icon(
              CupertinoIcons.layers,
            ),
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.checkmark,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "January 1, 2022 | xxx characters",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              CupertinoTextField(
                placeholder: "Title",
                padding: EdgeInsets.all(10.0),
              ),
              SizedBox(height: 10),
              CupertinoTextField(
                padding: EdgeInsets.all(10.0),
                maxLines: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
