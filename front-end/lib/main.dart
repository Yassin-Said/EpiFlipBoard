import 'package:epiflipboard/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'pages/feed_page.dart';
import 'pages/following_page.dart';
import 'pages/explore_page.dart';
import 'pages/notification_page.dart';
import 'pages/profile_page.dart';
import 'pages/profile/connexion/auth_selection_page.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(
  // DevicePreview(
  //   builder: (context) => const MyApp(),
  // ),
  const MyApp(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
      ),
      // Route initiale = FeedPage
      initialRoute: '/auth_page',
      routes: {
        '/auth_page': (context) => const AuthSelectionPage(),
        '/': (context) => const MainNavigation(),
        '/feed': (context) => const ForYouPage(),
        '/following': (context) => const FollowingPage(),
        '/explore': (context) => const ExplorePage(),
        '/notifications': (context) => const NotificationPage(),
        '/profile': (context) => const ProfilePage(),
      },
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

  // Les pages principales avec la bottom bar
  final List<Widget> _pages = [
    const ForYouPage(),        // Index 0 = Page d'accueil (Feed)
    const FollowingPage(),   // Index 1
    const ExplorePage(),     // Index 2
    const NotificationPage(),// Index 3
    const ProfilePage(),     // Index 4
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Feedpage",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Following",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white60,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
