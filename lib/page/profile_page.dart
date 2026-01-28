import 'package:flutter/cupertino.dart';

/// A profile page widget.
class ProfilePage extends StatelessWidget {
  /// Creates a [ProfilePage] instance.
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Profile'),
      ),
      child: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}
