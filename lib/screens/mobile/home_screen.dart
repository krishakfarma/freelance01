// ignore_for_file: public_member_api_docs, sort_constructors_first
// HomeScreen Widget
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook_reader/utils/colors.dart';
import 'package:ebook_reader/utils/styles.dart';
import 'package:ebook_reader/widgets/home_screen_widgets/custom_carousal_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ebook_reader/services/providers/books_provider.dart';
import 'package:ebook_reader/services/providers/home_provider.dart';
import 'package:ebook_reader/services/routing/app_routes_constants.dart';
import 'package:ebook_reader/utils/constants.dart';
import 'package:ebook_reader/utils/responsive.dart';
import 'package:ebook_reader/widgets/home_screen_widgets/book_card_widget.dart';
import 'package:ebook_reader/widgets/home_screen_widgets/section_header_widget.dart';

class HomeScreen extends StatelessWidget {
  final CarouselSliderController _controller1 = CarouselSliderController();
  final CarouselSliderController _controller2 = CarouselSliderController();
  final CarouselSliderController _latestBookcontroller = CarouselSliderController();

  HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    BooksProvider bookProvider = Provider.of<BooksProvider>(context);


    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, homeProvider, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Search Box
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8.w),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search here',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Responsive.isMobile(context) ? 35.h : 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Responsive.isMobile(context)
                      ? Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: AppColor.lightGrey,
                            border: Border.all(color: AppColor.mainOrangeColor),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(13),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Welcome to your marketplace of high-quality",
                                  style: AppStyles.mainHeading.copyWith(
                                    color: AppColor.blackColor, // You can change the color as needed
                                  ),
                                  textAlign: TextAlign.center, // Center the text
                                  overflow: TextOverflow.visible, // To prevent overflow if the text is too long
                                ),
                                Text(
                                  "E-Books",
                                  style: AppStyles.mainHeading.copyWith(
                                    color: AppColor.mainOrangeColor, // You can change the color as needed
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : AppConstants.homePageDesktopTabletHeading,
                  if (Responsive.isDesktop(context))
                    SizedBox(
                      width: 30.w,
                    ),
                  if (Responsive.isDesktop(context))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            _latestBookcontroller.previousPage();
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                        Container(
                          // height: 00,
                          color: Colors.transparent,
                          width: 300,
                          child: CarouselSlider(
                            carouselController: _latestBookcontroller,
                            items: bookProvider.latestBooks.map((e) {
                              return Center(
                                child: Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: CachedNetworkImageProvider(e.coverImageLink),
                                  )),
                                ),
                              );

                              //  BookCard(
                              //   title: e.title,
                              //   author: e.author.name,
                              //   imageUrl: e.coverImageLink,
                              //   onTap: () {},
                              // );
                            }).toList(),
                            options: AppConstants.carouselOptions,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _latestBookcontroller.nextPage();
                          },
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
                        ),
                      ],
                    ),
                ],
              ),

              //Trending Books
              const SizedBox(height: 24),
              SectionHeader(
                  title: 'Trending books',
                  onViewAll: () {
                    Navigator.pushNamed(context, AppRouteNames.trendingBooksScreen);
                  }),
              SizedBox(height: 8.h),
              if (Responsive.isDesktop(context) || Responsive.isTablet(context)) const SizedBox(height: 10),
              if (Responsive.isDesktop(context) || Responsive.isTablet(context))
                SizedBox(
                  height: 300,
                  // width: 00,
                  child: ListView.builder(
                    itemCount: bookProvider.suggestionBooks.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Expanded(
                            child: BookCard(
                              onTap: () {
                                Navigator.pushNamed(context, AppRouteNames.bookDetailsRoute,
                                    arguments: {'book': bookProvider.suggestionBooks[index]});
                                // context.push('/book_details_screen', extra: bookProvider.suggestionBooks[0]);
                              },
                              price: bookProvider.suggestionBooks[index].price,
                              title: bookProvider.suggestionBooks[index].title,
                              author: bookProvider.suggestionBooks[index].author.name,
                              imageUrl: bookProvider.suggestionBooks[index].coverImageLink,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              if (Responsive.isMobile(context))
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _controller1.previousPage();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    Expanded(
                      child: SizedBox(
                          // height: 800,
                          child: homeProvider.isLoading
                              ? const CustomCarousalSliderWithGrid4Loading()
                              : CustomCarousalSliderWithGrid4(
                        books: bookProvider.suggestionBooks,
                        carouselController: _controller1,
                      )),
                    ),
                    IconButton(
                      onPressed: () {
                        _controller1.nextPage();
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ],
                ),
              // Popular books
              SizedBox(height: 12.h),
              SectionHeader(title: 'Newest Release', onViewAll: () {}),
              SizedBox(height: 8.h),
              if (Responsive.isMobile(context))
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _controller2.previousPage();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    Expanded(
                      child: SizedBox(
                          child: homeProvider.isLoading
                              ? const CustomCarousalSliderWithGrid4Loading()
                              : CustomCarousalSliderWithGrid4(
                                  books: bookProvider.suggestionBooks,
                                  carouselController: _controller2,
                      )),
                    ),
                    IconButton(
                      onPressed: () {
                        _controller2.nextPage();
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ],
                ),
              if (Responsive.isDesktop(context)) const SizedBox(height: 10),
              if (Responsive.isDesktop(context) || Responsive.isTablet(context))
                SizedBox(
                  height: 300,
                  // width: 00,
                  child: ListView.builder(
                    itemCount: bookProvider.suggestionBooks.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Expanded(
                            child: BookCard(
                              onTap: () {
                                Navigator.pushNamed(context, AppRouteNames.bookDetailsRoute,
                                    arguments: {'book': bookProvider.suggestionBooks[index]});
                                // context.push('/book_details_screen', extra: bookProvider.suggestionBooks[0]);
                              },
                              price: bookProvider.suggestionBooks[index].price,
                              title: bookProvider.suggestionBooks[index].title,
                              author: bookProvider.suggestionBooks[index].author.name,
                              imageUrl: bookProvider.suggestionBooks[index].coverImageLink,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
