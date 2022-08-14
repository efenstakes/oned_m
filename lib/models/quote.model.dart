

class Quote {
  String? text;
  String? author;

  Quote({ required this.text, required this.author });

  static Quote fromMap(Map<String, dynamic> map) {
    return Quote(
      text: map['text'], 
      author: map['author'],
    );
  }
}