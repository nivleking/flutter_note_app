import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/components/floating_action_button.dart';
import 'package:flutter_note_app/components/note_card.dart';
import 'package:flutter_note_app/components/pop_menu.dart';
import 'package:flutter_note_app/models/note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Note> myNotes;
  final faker = Faker();
  String searchQuery = "";
  int columnCount = 2; // Default column count

  @override
  void initState() {
    super.initState();
    myNotes = Hive.box<Note>('notes');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: myNotes.listenable(),
      builder: (context, Box<Note> notes, _) {
        List<Note> sortedNotes = notes.values.toList();
        sortedNotes.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        List<Note> filteredNotes = sortedNotes.where((note) {
          return note.title.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
              note.content.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: TextField(
              decoration: InputDecoration(
                hintText: 'Search notes...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  final int? selectedColumnCount = await showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      int tempColumnCount = columnCount;
                      return AlertDialog(
                        title: Text('Set Column Count'),
                        content: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Enter number of columns"),
                          onChanged: (value) {
                            tempColumnCount =
                                int.tryParse(value) ?? columnCount;
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(tempColumnCount);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  // If the dialog returns a value, update the state
                  if (selectedColumnCount != null) {
                    setState(() {
                      columnCount = selectedColumnCount;
                    });
                  }
                },
              ),
              CustomPopMenu(),
            ],
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.all(10.0),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: columnCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (context, index) {
                    Note note = filteredNotes[index];
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
                  childCount: filteredNotes.length,
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
