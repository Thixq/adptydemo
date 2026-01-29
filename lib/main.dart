import 'package:adptydemo/env/dev_env.dart';
import 'package:adptydemo/locator.dart';
import 'package:adptydemo/page/root_page.dart';
import 'package:adptydemo/service_and_managers/adapty_service.dart';
import 'package:adptydemo/service_and_managers/note_db_service.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await locator<NoteDBService>().init();
  await locator<AdaptyService>().initialize(
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
