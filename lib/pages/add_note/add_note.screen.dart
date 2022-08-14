import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rich_editor/rich_editor.dart';



class AddNoteScreen extends StatefulWidget {
  bool isInScreen;

  AddNoteScreen({
    Key? key,
    this.isInScreen = false,
  }) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  GlobalKey<RichEditorState> keyEditor = GlobalKey();

  final _titleFocusNode = FocusNode();

  final TextEditingController _titleInputController = TextEditingController();



  @override
  void initState() {
    super.initState();

    _titleFocusNode.addListener(() {
      
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if( widget.isInScreen ) {
      return WillPopScope(
        child: RichEditor(
          key: keyEditor,
          value: 'Add your notes',
          editorOptions: RichEditorOptions(
            placeholder: 'Try typing',
            // backgroundColor: Colors.blueGrey, // Editor's bg color
            // baseTextColor: Colors.white,
            // editor padding
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            // font name
            baseFontFamily: 'sans-serif',
            // Position of the editing bar (BarPosition.TOP or BarPosition.BOTTOM)
            barPosition: BarPosition.TOP,
          ),
        ), 
        onWillPop: () async {
          // save here
          print("\n\n\n\n\n\n\n\n\n\n\n\n\nBack button pressed\n\n\n\n\n\n\n\n\n\n\n\n\n");
          
          print(await keyEditor.currentState?.getHtml());
          
          _addNote();

          return true;
        },
      );
    }
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 0,
          leading: null,
          title: Row(
            children: [
              InkWell(
                onTap: ()=> _goBack(context), 
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: 40,
                  child: const Icon(
                    Icons.keyboard_arrow_left, size: 32, color: Colors.brown, 
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  focusNode: _titleFocusNode,
                  textInputAction: TextInputAction.next,
                  controller: _titleInputController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note Title',
                  ),
                  onEditingComplete: () async {
                    _titleFocusNode.unfocus();
                    await keyEditor.currentState?.focus();
                  },
                ),
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.grey[100],        
        ),
        body: RichEditor(
          key: keyEditor,
          value: 'Add your notes',
          editorOptions: RichEditorOptions(
            placeholder: 'Try typing',
            // backgroundColor: Colors.blueGrey, // Editor's bg color
            // baseTextColor: Colors.white,
            // editor padding
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            // font name
            baseFontFamily: 'sans-serif',
            // Position of the editing bar (BarPosition.TOP or BarPosition.BOTTOM)
            barPosition: BarPosition.TOP,
          ),
        ),
      ), 
      onWillPop: () async {
        // save here
        print("\n\n\n\n\n\n\n\n\n\n\n\n\nBack button pressed\n\n\n\n\n\n\n\n\n\n\n\n\n");
        
        print(await keyEditor.currentState?.getHtml());
        
        _addNote();

        return true;
      },
    );
  }

  _goBack(BuildContext ctx) {
    Navigator.of(context).pop();
  }


  _addNote() async {
    var note = await keyEditor.currentState?.getHtml();
    var title = _titleInputController.text;

    try {
      var noteRef = FirebaseFirestore.instance.collection("notes").doc();

      noteRef.set({
        'id': noteRef.id,
        'title': title,
        'note': note,
        'user': FirebaseAuth.instance.currentUser?.uid,
      }).then((value) {
        // if ( widget.isInScreen ) {
          Navigator.of(context).pop();
        // }
      });

    } catch (e) {
      if (kDebugMode) {
        print("Failed to Save Note ${e.toString()}");
      }
    }
  }

}
