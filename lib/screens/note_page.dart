import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class NotePage extends StatefulWidget {
  final String mode;
  final String uuid;

  NotePage({
    super.key,
    required this.mode,
    required this.uuid,
  });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late Box<Note> myNotes;
  late Note note;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myNotes = Hive.box<Note>('notes');
    checkMode();

    _contentController.addListener(() {
      setState(() {});
    });
  }

  String getNoteTime() {
    var noteIndex = myNotes.values.toList().indexWhere(
          (note) => note.uuid == widget.uuid,
        );
    if (noteIndex == -1) return '';
    var note = myNotes.getAt(noteIndex);
    if (note != null) {
      var formatter = DateFormat('yyyy-MM-dd | hh:mm a');
      var formattedDate = formatter.format(note.date!.toLocal());
      return formattedDate +
          ' | ' +
          note.content.length.toString() +
          ' characters ';
    }
    return '';
  }

  void checkMode() {
    if (widget.mode == 'add') {
    } else {
      note = myNotes.values.firstWhere((note) => note.uuid == widget.uuid);
      _titleController.text = note.title;
      _contentController.text = note.content;
    }
  }

  Color selectedColor = Colors.white;

  Future addNote(String title, String content, Color color) async {
    await myNotes.add(
      Note(
        uuid: faker.guid.guid(),
        title: title,
        content: content,
        date: DateTime.now(),
      ),
    );
  }

  Future updateNote(String title, String content, Color color) async {
    var noteIndex = myNotes.values.toList().indexWhere(
          (note) => note.uuid == widget.uuid,
        );
    if (noteIndex != -1) {
      await myNotes.putAt(
        noteIndex,
        Note(
          uuid: widget.uuid,
          title: title,
          content: content,
          date: DateTime.now(),
        ),
      );
    }
  }

  void deleteNote() {
    var noteIndex = myNotes.values.toList().indexWhere(
          (note) => note.uuid == widget.uuid,
        );
    if (noteIndex != -1) {
      myNotes.deleteAt(noteIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.mode == 'add' ? 'Add Note' : 'Edit Note',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          widget.mode == 'add'
              ? SizedBox()
              : IconButton(
                  onPressed: () {
                    deleteNote();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note deleted!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  },
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
              Future<void> noteOperation;
              if (widget.mode == 'add') {
                noteOperation = addNote(
                  _titleController.text,
                  _contentController.text,
                  selectedColor,
                );
              } else {
                noteOperation = updateNote(
                  _titleController.text,
                  _contentController.text,
                  selectedColor,
                );
              }
              noteOperation.then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Note saved!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getNoteTime(),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  controller: _titleController,
                  placeholder: "Title",
                  padding: EdgeInsets.all(10.0),
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  controller: _contentController,
                  padding: EdgeInsets.all(10.0),
                  maxLines: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
      if (selectedColor != null) {
        setState(() {
          this.selectedColor = selectedColor;
        });
      }
    });
  }
}
