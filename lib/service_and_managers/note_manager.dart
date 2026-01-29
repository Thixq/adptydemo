import 'package:adptydemo/locator.dart';
import 'package:adptydemo/model/note_model.dart';
import 'package:adptydemo/service_and_managers/note_db_service.dart';
import 'package:adptydemo/service_and_managers/user_profile_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
// import for SubscriptionType ext if needed

/// Manages notes with respect to user profile and subscription status.
class NoteManager {
  final NoteDBService _dbService = locator<NoteDBService>();
  final UserProfileManager _userProfileManager = locator<UserProfileManager>();

  /// Expose listenable from DB Service seamlessly
  ValueListenable<Box<Note>> get listenable => _dbService.listenable;

  /// Returns true if the note was successfully added.
  /// Throws an exception or returns false if limit is reached.
  Future<void> createNote(Note note) async {
    final noteCount = _dbService.getNotes().length;
    final user = _userProfileManager.currentUser;

    if (!user.subscriptionType.isPremium && noteCount >= user.maxFreeNotes) {
      throw Exception(
        'Free limit reached. Upgrade to Premium to create more notes.',
      );
    }

    await _dbService.addNote(note);
  }

  /// Updates an existing note.
  Future<void> updateNote(Note note) async {
    // Allows updating even if limit is reached (usually allowed)
    await _dbService.addNote(note);
  }

  /// Deletes a note by its [id].
  Future<void> deleteNote(String id) async {
    await _dbService.deleteNote(id);
  }

  /// Retrieves all notes.
  List<Note> getAllNotes() {
    return _dbService.getNotes();
  }
}
