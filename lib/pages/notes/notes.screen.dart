import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:oned_m/models/note.model.dart';
import 'package:oned_m/pages/add_note/add_note.screen.dart';
import 'package:oned_m/widgets/content_loading.widget.dart';
import 'package:oned_m/widgets/no_content.widget.dart';
import 'package:oned_m/widgets/note.widget.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  
  List<Note> _notes = [];
  List<Note> _allNotes = [];

  bool _isLoadingNotes = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _getNotes();
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    int noteNumber = screenSize.width ~/ 320;


    return ListView(
      children: [

        ( !_isLoadingNotes && _allNotes.isEmpty ) 
            ?
              NoContentWidget(
                onPressCta: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx)=> AddNoteScreen()
                    )
                  );
                }, 
                showCta: true, 
                title: "No Notes", 
                text: "Click the add button to add a note",
                ctaText: "Add Note",
              )
            : Container(),

          ( _isLoadingNotes )
            ? ContentLoadingWidget(text: "Loading Notes")
            : Container(),
        const SizedBox(height: 40),

        GridView(
          physics: const ScrollPhysics(),
          primary: true,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: noteNumber,
            childAspectRatio: 2.2,
          ),
          children: [
            ..._allNotes.map((note) { 

              return NoteWidget( note: note );
            }).toList(),
          ],
        ),
        const SizedBox(height: 120),
        
      ],
    );
  }


  _getNotes() async {
    setState(()=> _isLoadingNotes = true);
    try {
      await FirebaseFirestore.instance
        .collection("notes")
        .where(
          'user', isEqualTo: FirebaseAuth.instance.currentUser!.uid 
        )
        .snapshots()
        .listen((snapshot) {
           
          List<Note> nts = [];
          for (var doc in snapshot.docs) {
            nts.add(Note.fromMap(doc.data()));
          }
          
          setState(() {
            _allNotes = nts;
            _isLoadingNotes = false;
          });
          
        });
    } catch (e) {
      print("error getting notes ${e.toString()}");
    }
    setState(()=> _isLoadingNotes = false);
  }

}