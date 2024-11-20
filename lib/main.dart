
import 'package:ebook_reader/Document-View-Idea/Model/book_progress_singleton.dart';
import 'package:ebook_reader/Document-View-Idea/show_epub.dart';
import 'package:ebook_reader/services/providers/auth_provider.dart';
import 'package:ebook_reader/services/providers/author_provider.dart';
import 'package:ebook_reader/services/providers/books_provider.dart';
import 'package:ebook_reader/services/providers/categories_provider.dart';
import 'package:ebook_reader/services/providers/home_provider.dart';
import 'package:ebook_reader/services/routing/app_route_config.dart';
import 'package:ebook_reader/services/routing/app_routes_constants.dart';
import 'package:ebook_reader/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bookProgress = BookProgressSingleton(prefs: prefs);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HomeProvider()),
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => BooksProvider()),
          ChangeNotifierProvider(create: (context) => AuthorProvider()),
          ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ],
        child: MaterialApp(
          initialRoute: AppRouteNames.splashScreeRoute,
          onGenerateRoute: RouteGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
          title: 'EBook Reader',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColor.mainOrangeColor),
            useMaterial3: true,
          ),
          // home: BottomBar()
        ),
      ),
    );
  }
}
