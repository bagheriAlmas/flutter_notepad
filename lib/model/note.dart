String tableNotes = 'tbl_notes';

class Note {
  final int? id;
  final String? title;
  final String? content;
  final String? color;
  final String? date;

  Note({this.id, this.title, this.content, this.color,this.date});

  Map<String, Object?> toJson() => {
        NotesFields.id: id,
        NotesFields.title: title,
        NotesFields.content: content,
        NotesFields.color: color,
        NotesFields.date: date
      };

  static Note fromJson(Map<String,Object?> json) =>Note(
    id:json[NotesFields.id] as int?,
    title:json[NotesFields.title] as String,
    content:json[NotesFields.content] as String,
    color:json[NotesFields.color] as String,
    date:json[NotesFields.date] as String,
  );

  Note copy({int? id,String? title,String? content,String? color,String? date}) => Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    color: color ?? this.color,
    date: date ?? this.date
  );
}

class NotesFields {
  static final List<String> values = [id, title, content,color,date];
  static const String id = '_id';
  static const String title = '_title';
  static const String content = '_content';
  static const String color = '_color';
  static const String date = '_date';
}
