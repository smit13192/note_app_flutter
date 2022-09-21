class Note {
  int? id;
  String title;
  String desc;
  int priority;

  Note(this.title, this.desc, this.priority);

  Note.withId(this.id, this.title, this.desc, this.priority);

  factory Note.fromMap(Map<String, Object?> map) => Note.withId(
      map["id"] as int,
      map["title"] as String,
      map["desc"] as String,
      map["priority"] as int);

  Map<String, Object?> toMap() =>
      {"id": id, "title": title, "desc": desc, "priority": priority};

  Note copy({int? id, String? title, String? desc, int? priority}) =>
      Note.withId(id ?? id, title ?? this.title, desc ?? this.desc,
          priority ?? this.priority);
}
