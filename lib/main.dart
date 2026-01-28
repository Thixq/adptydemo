import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adptydemo/env/dev_env.dart';
import 'package:adptydemo/page/root_page.dart';
import 'package:adptydemo/service/adapty_service.dart';
import 'package:adptydemo/service/note_service.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteService().init();
  await AdaptyService(adapty: Adapty()).initialize(
    apiKey: DevEnv().adaptyApiKey,
  );
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: RootPage(),
    );
  }
}
