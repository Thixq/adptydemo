import 'package:adptydemo/component/note_card.dart';
import 'package:adptydemo/model/note_model.dart';
import 'package:flutter/cupertino.dart';

/// A widget that displays a list of notes.
class NoteViewer extends StatelessWidget {
  /// Creates a [NoteViewer] instance.
  const NoteViewer({
    required this.notes,
    super.key,
    this.onNoteTap,
  });

  /// The list of notes to display.
  final List<Note> notes;

  /// The callback to invoke when a note is tapped.
  final ValueChanged<Note>? onNoteTap;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(
        child: Text(
          'Henüz not eklenmedi.',
          style: TextStyle(
            color: CupertinoColors.secondaryLabel,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onTap: () => onNoteTap?.call(note),
        );
      },
    );
  }
}
