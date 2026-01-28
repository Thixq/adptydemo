import 'package:adptydemo/model/note_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A service class for managing notes using Hive database.
class NoteService {
  /// Returns the singleton instance of [NoteService].
  factory NoteService() => _instance;
  NoteService._internal();
  static const String _boxName = 'notes';

  static final NoteService _instance = NoteService._internal();

  Box<Note>? _box;

  /// Initializes the Hive database and opens the notes box.
  Future<void> init() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(NoteAdapter());
      _box = await Hive.openBox<Note>(_boxName);
      debugPrint('NoteService initialized');
    } catch (e) {
      debugPrint('Error initializing NoteService: $e');
      rethrow;
    }
  }

  /// Returns a [ValueListenable] for the notes box.
  ValueListenable<Box<Note>> get listenable {
    _checkInitialized();
    return _box!.listenable();
  }

  /// Fetches all notes from the Hive database.
  List<Note> getNotes() {
    _checkInitialized();
    final notes = _box!.values.toList().cast<Note>();
    debugPrint('Fetched ${notes.length} notes');
    return notes;
  }

  /// Adds a new note to the Hive database.
  Future<void> addNote(Note note) async {
    _checkInitialized();
    await _box!.put(note.id, note);
    debugPrint('Added note: ${note.id} - ${note.title}');
  }

  /// Deletes a note from the Hive database by its [id].
  Future<void> deleteNote(String id) async {
    _checkInitialized();
    await _box!.delete(id);
    debugPrint('Deleted note: $id');
  }

  void _checkInitialized() {
    if (_box == null) {
      throw Exception('NoteService not initialized. Call init() first.');
    }
  }
}
