import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/components/floating_action_button.dart';
import 'package:flutter_note_app/components/note_card.dart';
import 'package:flutter_note_app/components/pop_menu.dart';
import 'package:flutter_note_app/models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Note> myNotes;
  final faker = Faker();

  void printNotes() {
    var notes = myNotes.values.toList();
    for (var note in notes) {
      print(
          'UUID: ${note.uuid}, Title: ${note.title}, Content: ${note.content}');
    }
  }

  @override
  void initState() {
    super.initState();
    myNotes = Hive.box<Note>('notes');
    // printNotes();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: myNotes.listenable(),
      builder: (context, Box<Note> notes, _) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                floating: true,
                snap: false,
                pinned: true,
                actions: [
                  CustomPopMenu(),
                ],
              ),
              SliverPadding(
                padding: EdgeInsets.all(10.0),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: List.generate(
                    notes.length,
                    (index) {
                      Note note = notes.getAt(index)!;
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/note',
                          arguments: {
                            'mode': '',
                            'uuid': note.uuid,
                          },
                        ),
                        child: NoteCard(
                          note: note,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: CustomFloatingActionButton(),
        );
      },
    );
  }
}
