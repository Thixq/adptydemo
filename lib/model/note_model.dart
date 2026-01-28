import 'package:hive/hive.dart';

/// A model class representing a Note.
class Note {
  /// Creates a [Note] instance.
  Note({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
  });

  /// The unique identifier of the note.
  final String id;

  /// The creation date of the note.
  final DateTime createdAt;

  /// The title of the note.
  final String title;

  /// The description of the note.
  final String description;
}

/// A Hive adapter for the [Note] model.
class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
      id: reader.read() as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.read() as int),
      title: reader.read() as String,
      description: reader.read() as String,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..write(obj.id)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..write(obj.title)
      ..write(obj.description);
  }
}
