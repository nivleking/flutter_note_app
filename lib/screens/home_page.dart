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
    Brightness theme = MediaQuery.of(context).platformBrightness;
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
              PopupMenuButton<int>(
                onSelected: (int result) {
                  setState(() {
                    columnCount = result;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text('2 Columns'),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: Text('3 Columns'),
                  ),
                  const PopupMenuItem<int>(
                    value: 4,
                    child: Text('4 Columns'),
                  ),
                ],
              ),
              CustomPopMenu(),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(8.0),
              child: Divider(
                height: 8.0,
                color: theme == Brightness.light
                    ? Colors.grey[300]
                    : Colors.grey[800]!,
                thickness: 0.3,
              ),
            ),
            backgroundColor:
                theme == Brightness.light ? Colors.white : Colors.grey[800]!,
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.all(15.0),
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
