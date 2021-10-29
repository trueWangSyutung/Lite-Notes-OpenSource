class Note {
  int id;
  String title;
  String text;
  String date;

  Note(this.id, this.title, this.text, this.date);
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'text': text, 'date': date};
  }

  Map<String, dynamic> toUpdateMap() {
    return {'title': title, 'text': text};
  }

  bool isIn(List lists) {
    bool a = lists.indexWhere((element) => element.id == id) != -1;
    return a;
  }

  bool isSame(List lists) {
    int a = lists.indexWhere((element) => element.id == id);
    Note b = lists[a];
    return (b.title == title) && (b.text == text);
  }
}
