import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class NotePage extends StatefulWidget {
  final String mode;
  final String uuid;

  const NotePage({
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
      var formatter = DateFormat('yyyy-MM-dd hh:mm a');
      var formatDateEdit = formatter.format(note.date!.toLocal());
      var formatDateCreated = formatter.format(note.createdAt!.toLocal());
      return 'Created at: ' +
          formatDateCreated +
          '\n' +
          'Last edit: ' +
          formatDateEdit +
          '\n' +
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

  Future addNote(String title, String content) async {
    await myNotes.add(
      Note(
        uuid: faker.guid.guid(),
        title: title,
        content: content,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future updateNote(String title, String content) async {
    var noteIndex = myNotes.values.toList().indexWhere(
          (note) => note.uuid == widget.uuid,
        );

    if (noteIndex != -1) {
      var oldNote = myNotes.getAt(noteIndex);
      await myNotes.putAt(
        noteIndex,
        Note(
          uuid: widget.uuid,
          title: title,
          content: content,
          date: DateTime.now(),
          createdAt: oldNote?.date ?? DateTime.now(),
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
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          widget.mode == 'add'
              ? const SizedBox()
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
                  icon: const Icon(
                    CupertinoIcons.trash,
                    color: Colors.red,
                  ),
                ),
          IconButton(
            icon: const Icon(
              CupertinoIcons.checkmark,
              color: Colors.green,
            ),
            onPressed: () {
              Future<void> noteOperation;
              if (widget.mode == 'add') {
                noteOperation = addNote(
                  _titleController.text,
                  _contentController.text,
                );
              } else {
                noteOperation = updateNote(
                  _titleController.text,
                  _contentController.text,
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
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Total characters: ${_contentController.text.length}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                CupertinoTextField(
                  controller: _titleController,
                  placeholder: "Title",
                  padding: const EdgeInsets.all(10.0),
                ),
                const SizedBox(height: 10),
                CupertinoTextField(
                  controller: _contentController,
                  padding: const EdgeInsets.all(10.0),
                  maxLines: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void showColorPicker() {
  //   List<String> colors = [
  //     "white",
  //     "blue",
  //     "green",
  //     "red",
  //     "yellow",
  //   ];
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SizedBox(
  //         height: 120,
  //         child: GridView.count(
  //           crossAxisCount: 5,
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 10.0,
  //             vertical: 20.0,
  //           ),
  //           children: colors.map((String colorName) {
  //             Color color = Colors.white; // Default to white if not found
  //             switch (colorName) {
  //               case "white":
  //                 color = Colors.white;
  //                 break;
  //               case "blue":
  //                 color = Colors.blue;
  //                 break;
  //               case "green":
  //                 color = Colors.green;
  //                 break;
  //               case "red":
  //                 color = Colors.red;
  //                 break;
  //               case "yellow":
  //                 color = Colors.yellow;
  //                 break;
  //             }

  //             return GestureDetector(
  //               onTap: () {
  //                 Navigator.pop(context, color);
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.all(4.0),
  //                 child: Container(
  //                   color: color,
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       );
  //     },
  //   ).then((selectedColor) {
  //     if (selectedColor != null) {
  //       setState(() {
  //         this.selectedColor = selectedColor as Color;
  //       });
  //     }
  //   });
  // }
}
