import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/subscribe_page.dart';
import 'pages/explore_page.dart';
import 'pages/notification_page.dart';
import 'pages/profile_page.dart';
import 'package:device_preview/device_preview.dart';
import 'pages/feed_page.dart';

void main() => runApp(
  DevicePreview(
    builder: (context) => MyApp(), // Wrap your app
  ),
);

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    FeedPage(),
    SubscribePage(),
    ExplorePage(),
    NotificationPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Subscription"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}

// @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // home: const MainNavigation(),
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
//       ),
//       routes: {
//         '/': (context) => const HomePage(),
//         '/profile': (context) => const ProfilePage(),
//         '/subscribe': (context) => const SubscribePage(),
//         '/explore': (context) => const ExplorePage(),
//         '/notifications': (context) => const NotificationPage()
//       },
//     );
//   }