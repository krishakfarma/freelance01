import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook_reader/services/models/book_model.dart';
import 'package:ebook_reader/services/routing/app_routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class BookCarousalWidget extends StatelessWidget {
  Book book;
  BookCarousalWidget({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouteNames.bookDetailsRoute, arguments: {'book': book});
      },
      child: Container(
        height: 200.h,
        width: 100.w,
        // color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              child: CachedNetworkImage(
                imageUrl: book.coverImageLink,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
            Text(book.author.name, style: const TextStyle(color: Colors.grey, fontSize: 12.5)),
            Text(book.price == null ? "Free" : "₹${book.price}",
                style: const TextStyle(color: Colors.black, fontSize: 12.5)),
          ],
        ),
      ),
    );
  }
}
