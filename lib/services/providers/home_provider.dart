// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ebook_reader/screens/mobile/author_screen.dart';
import 'package:ebook_reader/screens/mobile/home_screen.dart';
import 'package:ebook_reader/screens/mobile/latest_books_screen.dart';
import 'package:ebook_reader/screens/mobile/profile_screen.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider() {
    changeLoading();
  }
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  // List of screen widgets
  final List<Widget> _screens = [
    HomeScreen(),
    const LatestScreen(),
    const AuthorScreen(),
   const ProfileScreen(),
  ];
  List<Widget> get screens => _screens;

  // List of screen names
  final List<String> _screenTitles = [
    'Hello,',
    'Categories',
    'Latest',
    'Author',
    'Profile',
  ];
  List<String> get screenTitles => _screenTitles;

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  //Home Data

  bool isLoading = true;

  void changeLoading() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        isLoading = false;
        notifyListeners();
        debugPrint("Loading status changed to: $isLoading");
      },
    );
  }
}
