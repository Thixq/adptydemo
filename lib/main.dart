import 'package:adptydemo/page/demo_page.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: DemoPage(),
    );
  }
}
