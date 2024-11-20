import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook_reader/utils/constants.dart';
import 'package:ebook_reader/widgets/home_screen_widgets/book_carousal_widget.dart';
import 'package:flutter/material.dart';
import 'package:ebook_reader/services/models/book_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomCarousalSliderWithGrid4 extends StatelessWidget {
  final List<Book> books;
  final CarouselSliderController carouselController;
  const CustomCarousalSliderWithGrid4({
    Key? key,
    required this.books,
    required this.carouselController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      
      carouselController: carouselController,
      items: List.generate((books.length / 4).ceil(), (index) {
        final book1 = books[index * 4];
        final book2 = index * 4 + 1 < books.length ? books[index * 4 + 1] : null;

        final book3 = index * 4 + 2 < books.length ? books[index * 4 + 2] : null;

        final book4 = index * 4 + 3 < books.length ? books[index * 4 + 3] : null;

        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 35.w,
                ),
                BookCarousalWidget(book: book1),
                const SizedBox(
                  width: 10,
                ),
                if (book2 != null) BookCarousalWidget(book: book2)
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                if (book3 != null)
                  SizedBox(
                    width: 35.w,
                  ),
                if (book3 != null)
                  BookCarousalWidget(
                    book: book3,
                  ),
                const SizedBox(
                  width: 10,
                ),
                if (book4 != null)
                  BookCarousalWidget(
                    book: book4,
                  ),
              ],
            ),
          ],
        );
      }),
      options: AppConstants.carouselOptions,
    );
  }
}

class CustomCarousalSliderWithGrid4Loading extends StatelessWidget {
  const CustomCarousalSliderWithGrid4Loading({
    Key? key,
  }) : super(key: key);
  Widget _buildLoadingItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.w, // Adjust as per the BookCarousalWidget's dimensions
            height: 150.h, // Adjust as per the BookCarousalWidget's dimensions
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Container(
            width: 80.w, // Adjust as per the BookCarousalWidget's dimensions
            height: 15.h, // Adjust as per the BookCarousalWidget's dimensions
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Container(
            width: 50.w, // Adjust as per the BookCarousalWidget's dimensions
            height: 15.h, // Adjust as per the BookCarousalWidget's dimensions
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: List.generate((4), (index) {
        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 35.w,
                ),
                _buildLoadingItem(),
                const SizedBox(
                  width: 10,
                ),
                _buildLoadingItem()
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 35.w,
                ),
                _buildLoadingItem(),
                const SizedBox(
                  width: 10,
                ),
                _buildLoadingItem()
              ],
            ),
          ],
        );
      }),
      options: AppConstants.carouselOptions,
    );
  }
}
