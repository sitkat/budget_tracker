import 'package:budget_tracker/ui/settings_screen.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_custom_icon_accent.dart';
import 'add_entry_screen.dart';
import 'history_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _MyAppState();
}

class _MyAppState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final tabs = const [
    HistoryScreen(),
    AddEntryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: BottomNavigationBar(
            iconSize: 30.0,
            unselectedIconTheme: Theme.of(context).iconTheme,
            selectedItemColor: AppColors.accent,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: CustomIconAccent(icon: Icons.add_circle),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: '',
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}