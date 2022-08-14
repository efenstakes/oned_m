import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oned_m/models/note.model.dart';
import 'package:oned_m/pages/add_note/add_note.screen.dart';

class NoteScreen extends StatefulWidget {
  final Note note;

  const NoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    Note note = widget.note;

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title!),
      ),
      body: SizedBox.expand(
        child: Html(data: note.text!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx)=> AddNoteScreen(note: note))
          );
        },
        mini: false,
        backgroundColor: Colors.black87,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}