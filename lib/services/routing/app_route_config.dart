import 'package:ebook_reader/auth/signin_screen.dart';
import 'package:ebook_reader/auth/signup_screen.dart';
import 'package:ebook_reader/screens/mobile/book_details_screen.dart';
import 'package:ebook_reader/screens/mobile/bottom_bar.dart';
import 'package:ebook_reader/screens/mobile/cart_screen.dart';
import 'package:ebook_reader/screens/mobile/epub_viewer_screen_test_asset.dart';
import 'package:ebook_reader/screens/mobile/pdf_viewer.dart';
import 'package:ebook_reader/screens/mobile/splash_screen.dart';
import 'package:ebook_reader/screens/mobile/trending_books_screen.dart';
import 'package:ebook_reader/services/models/book_model.dart';
import 'package:ebook_reader/services/routing/app_routes_constants.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case AppRouteNames.splashScreeRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRouteNames.homeRoute:
        return MaterialPageRoute(builder: (_) => BottomBar());

      case AppRouteNames.bookDetailsRoute:
        if (args is Map<String, dynamic> && args.containsKey('book')) {
          Book book = args['book'] as Book;
          List<Book> relatedBooks = [book, book, book, book];
          return MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book, relatedBooks: relatedBooks));
        }
        return _errorRoute();

      case AppRouteNames.pdfViewerRoute:
        if (args is Map<String, dynamic> &&
            args.containsKey('title') &&
            args.containsKey('id') &&
            args.containsKey('link')) {
          String pdfLink = args['link'] as String;
          String title = args['title'] as String;
          String id = args['id'] as String;

          return MaterialPageRoute(builder: (_) => PdfViewerScreen(pdfLink: pdfLink, title: title, id: id));
        }
        return _errorRoute();

      // case AppRouteNames.cosmosEpubReaderiOsAndroid:
      //   if (args is Map<String, dynamic> && args.containsKey('url')) {
      //     String url = args['url'] as String;
      //     return MaterialPageRoute(builder: (_) => CosmosEpubReaderiOsAndroid(url: url));
      //   }

      //   return _errorRoute();

      case AppRouteNames.epubViewerRoute:
        if (args is Map<String, dynamic> && args.containsKey('url') && args.containsKey('id')) {
          String url = args['url'] as String;
          String id = args['id'] as String;

          return MaterialPageRoute(
              builder: (_) => EpubViewer(
                    url: url,
                    id: id,
                  ));
        }
        return _errorRoute();

      case AppRouteNames.cartScreen:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case AppRouteNames.trendingBooksScreen:
        return MaterialPageRoute(builder: (_) => const TrendingBooks());

      case AppRouteNames.signInRoute:
        return MaterialPageRoute(builder: (_) => SignInScreen());

      case AppRouteNames.signUpRoute:
        return MaterialPageRoute(builder: (_) => SignUpScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text(
            'ERROR',
            style: TextStyle(fontSize: 30),
          ),
        ),
      );
    });
  }
}
