class Note {
  int? _id;
  String title;
  String desc;

  Note(this.title, this.desc);

  Note.withId(this._id, this.title, this.desc);

  factory Note.fromMap(Map<String, dynamic> map) =>
      Note.withId(map["id"], map["id"], map["desc"]);

  Map<String, dynamic> toMap() => {"id": _id, "title": title, "desc": desc};

  int? get id => _id;
}
