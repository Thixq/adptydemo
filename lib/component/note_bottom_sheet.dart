import 'package:adptydemo/model/note_model.dart';
import 'package:adptydemo/service_and_managers/note_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// A bottom sheet widget for creating or editing a note.
class NoteBottomSheet extends StatefulWidget {
  /// Creates a [NoteBottomSheet] instance.
  const NoteBottomSheet({super.key, this.note});

  /// The note to be edited, or null if creating a new note.
  final Note? note;

  @override
  State<NoteBottomSheet> createState() => _NoteBottomSheetState();
}

class _NoteBottomSheetState extends State<NoteBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  bool _isTitleEmpty = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _noteController = TextEditingController(text: widget.note?.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    setState(() {
      _isTitleEmpty = _titleController.text.trim().isEmpty;
    });

    if (_isTitleEmpty) {
      return;
    }

    final note = Note(
      id: widget.note?.id ?? const Uuid().v4(),
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      title: _titleController.text.trim(),
      description: _noteController.text.trim(),
    );

    try {
      if (widget.note != null) {
        await NoteManager().updateNote(note);
      } else {
        await NoteManager().createNote(note);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        await showCupertinoDialog<void>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Limit Reached'),
            content: Text(e.toString().replaceAll('Exception: ', '')),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    widget.note == null ? 'New Note' : 'Edit Note',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    onPressed: _onSave,
                    child: const Text('Save'),
                  ),
                ],
              ),
              const Divider(height: 1, color: CupertinoColors.separator),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoTextField(
                      controller: _titleController,
                      placeholder: 'Note Title',
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isTitleEmpty
                              ? CupertinoColors.destructiveRed
                              : CupertinoColors.systemGrey4,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onChanged: (value) {
                        if (_isTitleEmpty && value.isNotEmpty) {
                          setState(() {
                            _isTitleEmpty = false;
                          });
                        }
                      },
                    ),
                    if (_isTitleEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 4, left: 4),
                        child: Text(
                          'Title is required',
                          style: TextStyle(
                            color: CupertinoColors.destructiveRed,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    CupertinoTextField(
                      controller: _noteController,
                      placeholder: 'Your Note...',
                      padding: const EdgeInsets.all(12),
                      minLines: 3,
                      maxLines: 8,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CupertinoColors.systemGrey4,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
