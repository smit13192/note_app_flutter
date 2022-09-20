class Note {
  int? id;
  String title;
  String desc;

  Note({this.id, required this.title, required this.desc});

  factory Note.fromMap(Map<String, Object?> map) => Note(
      id: map["id"] as int?,
      title: map["title"] as String,
      desc: map["desc"] as String);

  Map<String, Object?> toMap() => {"id": id, "title": title, "desc": desc};

  Note copy({int? id, String? title, String? desc}) => Note(
      id: id ?? this.id, title: title ?? this.title, desc: desc ?? this.desc);
}
