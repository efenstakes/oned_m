


class Note {
  String? id;
  String? title;
  String? text;

  Note({ 
    this.id,
    this.title,
    this.text,
  });


  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      text: map['note'], 
    );
  }

}