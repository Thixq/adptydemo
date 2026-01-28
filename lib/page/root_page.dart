import 'package:adptydemo/page/home_page.dart';
import 'package:adptydemo/page/profile_page.dart';
import 'package:flutter/cupertino.dart';

/// The root page widget with tab navigation.
class RootPage extends StatelessWidget {
  /// Creates a [RootPage] instance.
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const HomePage(),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const ProfilePage(),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
