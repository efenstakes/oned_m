import 'package:flutter/material.dart';
// import 'package:flutter_native_html_view/flutter_native_html_view.dart';
import 'package:oned_m/models/note.model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oned_m/pages/note/note.screen.dart';



class NoteWidget extends StatefulWidget {
  final Note note;

  const NoteWidget({Key? key, required this.note }) : super(key: key);

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: ()=> Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctxt)=> NoteScreen(note: widget.note,)
        )
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(
            maxHeight: 200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // title
              Text(
                widget.note.title!,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              
              // note
              LimitedBox(
                maxHeight: 64,
                child: Html(
                  data: widget.note.text!
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}
