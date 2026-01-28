import 'package:adptydemo/model/note_model.dart';
import 'package:flutter/cupertino.dart';

/// A card widget that displays a note.
class NoteCard extends StatelessWidget {
  /// Creates a [NoteCard] instance.
  const NoteCard({
    required this.note,
    super.key,
    this.onTap,
  });

  /// The note to display.
  final Note note;

  /// The callback to invoke when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final textStyle = theme.textTheme.textStyle;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey
                  .resolveFrom(context)
                  .withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: textStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(note.createdAt),
              style: textStyle.copyWith(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              note.description,
              style: textStyle.copyWith(
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
