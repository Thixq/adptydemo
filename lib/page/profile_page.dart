import 'package:adptydemo/component/premium_status_card.dart';
import 'package:adptydemo/component/user_card.dart';
import 'package:flutter/cupertino.dart';

/// A profile page widget.
class ProfilePage extends StatelessWidget {
  /// Creates a [ProfilePage] instance.
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Profile'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const UserCard(),
              const SizedBox(height: 16),
              const PremiumStatusCard(),
              const Spacer(),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
