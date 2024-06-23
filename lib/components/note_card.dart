import 'package:flutter/material.dart';
import 'package:flutter_note_app/models/note.dart';
import 'package:intl/intl.dart'; // Import intl package

class NoteCard extends StatelessWidget {
  final Note note;
  NoteCard({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    Brightness theme = MediaQuery.of(context).platformBrightness;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme == Brightness.light ? Colors.white : Colors.grey[900]!,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: theme == Brightness.light
                ? Colors.grey[300]!
                : Colors.grey[800]!,
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Text(
                note.content,
                style: TextStyle(
                  fontSize: 12,
                  color: theme == Brightness.light
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
            ],
          ),
          Text(
            DateFormat('yyyy-MM-dd hh:mm a').format(note.createdAt!),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
