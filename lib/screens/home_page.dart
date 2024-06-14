import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                  PopupMenuButton<String>(
                    color: Colors.blue,
                    icon: Icon(CupertinoIcons.gear),
                    onSelected: (value) {
                      if (value == 'logout') {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SliverPadding(
                padding: EdgeInsets.all(10.0),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: List.generate(notes.length, (index) {
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
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              note.content,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
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
          ),
        );
      },
    );
  }
}
