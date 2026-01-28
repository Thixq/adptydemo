import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:adptydemo/component/note_bottom_sheet.dart';
import 'package:adptydemo/component/note_viewer.dart';
import 'package:adptydemo/model/note_model.dart';
import 'package:adptydemo/service/note_service.dart';

/// A home page widget.
class HomePage extends StatefulWidget {
  /// Creates a [HomePage] instance.
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Home'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await showCupertinoModalPopup<void>(
              context: context,
              builder: (context) => const NoteBottomSheet(),
            );
          },
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: ValueListenableBuilder<Box<Note>>(
        valueListenable: NoteService().listenable,
        builder: (context, box, _) {
          final notes = box.values.toList().cast<Note>();
          return SafeArea(
            bottom: false,
            child: NoteViewer(
              notes: notes,
              onNoteTap: (note) async {
                await showCupertinoModalPopup<void>(
                  context: context,
                  builder: (context) => NoteBottomSheet(note: note),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
