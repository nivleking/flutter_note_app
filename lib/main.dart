import 'package:flutter/material.dart';
import 'package:flutter_note_app/models/note.dart';
import 'package:flutter_note_app/models/pin.dart';
import 'package:flutter_note_app/screens/note_page.dart';
import 'package:flutter_note_app/screens/home_page.dart';
import 'package:flutter_note_app/screens/login_page.dart';
import 'package:flutter_note_app/screens/register_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(PinAdapter());
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Pin>('pins');

  Hive.box<Note>('notes').clear();

  runApp(
    MyApp(
      isFirstTime: Hive.box<Pin>('pins').isEmpty,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  const MyApp({
    super.key,
    required this.isFirstTime,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white38),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          background: Colors.black,
          primary: Colors.white,
          brightness: Brightness.dark,
          onPrimary: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/note': (context) => NotePage(
              mode: (ModalRoute.of(context)?.settings.arguments as Map)['mode'],
              uuid: (ModalRoute.of(context)?.settings.arguments as Map)['uuid'],
            ),
      },
      initialRoute: isFirstTime ? '/register' : '/login',
    );
  }
}
