import 'package:ebook_reader/services/providers/books_provider.dart';
import 'package:ebook_reader/services/routing/app_routes_constants.dart';
import 'package:ebook_reader/utils/colors.dart';
import 'package:ebook_reader/widgets/home_screen_widgets/book_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TrendingBooks extends StatelessWidget {
  const TrendingBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.appBarBackgroundColor,
          title: const Text(
            "Trending Books",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )),
      body: ChangeNotifierProvider(
        create: (_) => BooksProvider(),
        child: Consumer<BooksProvider>(
          builder: (context, booksProvider, _) => SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 15.h,
                      crossAxisSpacing: 15.w,
                    ),
                    itemCount: booksProvider.suggestionBooks.length,
                    itemBuilder: (context, index) {
                      // final book = relatedBooks[index];
                      return BookCard(
                        title: booksProvider.suggestionBooks[index].title,
                        author: booksProvider.suggestionBooks[index].author.name,
                        imageUrl: booksProvider.suggestionBooks[index].coverImageLink,
                        price: booksProvider.suggestionBooks[index].price,
                        onTap: () {
                          Navigator.pushNamed(context, AppRouteNames.bookDetailsRoute,
                              arguments: {'book': booksProvider.suggestionBooks[index]});
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
