import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinput/pinput.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showAddNoteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CupertinoTextField(
                placeholder: "Title",
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              SizedBox(height: 10),
              CupertinoTextField(
                placeholder: "Content",
                padding: EdgeInsets.all(10.0),
                maxLines: 5,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              SizedBox(height: 10),
              CupertinoButton(
                color: Colors.blue,
                child: Text("Add"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  late Box<Note> myNotes;

  @override
  void initState() {
    super.initState();
    myNotes = Hive.box<Note>('notes');
    // myNotes.add(
    //   // Note(
    //   //   uuid: '1',
    //   //   title: 'Sample Note',
    //   //   content: 'This is a sample note.',
    //   //   // color: Colors.blue,
    //   //   // date: DateTime.now(),
    //   // ),
    // );
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                floating: true,
                snap: false,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(CupertinoIcons.gear),
                    onPressed: () {},
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
                                fontSize: 18,
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
                },
              );
            },
          ),
        );
      },
    );
  }
}
