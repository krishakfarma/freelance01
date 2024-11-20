import 'package:ebook_reader/screens/mobile/home_screen.dart';
import 'package:ebook_reader/services/providers/home_provider.dart';
import 'package:ebook_reader/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BottomBar extends StatelessWidget {
  BottomBar({super.key});

  var popupMenuItemIndex = 0;
  String currentPage = "Home";
  var appBarHeight = AppBar().preferredSize.height;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, homeProvider, _) => Scaffold(
          appBar: AppConstants.customAppBar(
            context,
            homeProvider.selectedIndex != 0,
            homeProvider.selectedIndex == 0 ? 'Home' : homeProvider.screenTitles[homeProvider.selectedIndex],
            false,
            false
          ) as PreferredSizeWidget,
          body: HomeScreen(),
        ),
      ),
    );
  }
}

