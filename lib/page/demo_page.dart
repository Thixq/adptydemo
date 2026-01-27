import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A demo page widget.
class DemoPage extends StatefulWidget {
  /// Creates a [DemoPage] instance.
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Adapty Demo'),
      ),
      child: Center(
        child: Text('Welcome to Aaadapty Demo App!'),
      ),
    );
  }
}
