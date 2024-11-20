import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:ebook_reader/services/routing/app_routes_constants.dart';
import 'package:ebook_reader/utils/colors.dart';
import 'package:ebook_reader/utils/responsive.dart';
import 'package:ebook_reader/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum Options { search, share, copy, logout }

class AppConstants {
  static String userIconLink = "https://cdn-icons-png.flaticon.com/512/9203/9203764.png";

  static CarouselOptions carouselOptions = CarouselOptions(
    height: 410,
    aspectRatio: 0,
    viewportFraction: 1,
    initialPage: 0,
    enableInfiniteScroll: false,
    reverse: false,
    autoPlay: false,
    autoPlayInterval: const Duration(seconds: 3),
    autoPlayAnimationDuration: const Duration(milliseconds: 800),
    autoPlayCurve: Curves.fastOutSlowIn,
    enlargeCenterPage: true,
    enlargeFactor: 0.4,
    enlargeStrategy: CenterPageEnlargeStrategy.zoom,
    onPageChanged: (int i, CarouselPageChangedReason c) {
      //Implement Function to Get 4 New Books and add them to carousal
    },
    scrollDirection: Axis.horizontal,
  );

  
  static Widget homePageDesktopTabletHeading = Column(
    children: [
      const Center(
        child: Text(
          "Welcome to your marketplace of",
          style: AppStyles.mainHeading,
        ),
      ),
      const Center(
        child: Text(
          "high-quality",
          style: AppStyles.mainHeading,
        ),
      ),
      Center(
        child: Text(
          "E-Books &",
          style: AppStyles.mainHeading.copyWith(color: AppColor.mainOrangeColor),
        ),
      ),
    ],
  );
  //App bar

  static void openBottomDrawer(BuildContext context) {
    if (!Responsive.isDesktop(context)) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        isScrollControlled: true, // Allows the modal to use more space
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.75, // Adjust the height factor to control drawer height (90% of screen height)
            widthFactor: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Ebook Reader',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Text(
                    'Scroll Down to view all categories',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _buildCategoryButton(context, Icons.home, 'Biography & Memoir',
                                  "https://cdn1.iconfinder.com/data/icons/literary-genres-color/64/biography-life-story-writer-memoir-history-512.png"),
                              _buildCategoryButton(context, Icons.book, 'Non-Fiction',
                                  "https://cdn-icons-png.freepik.com/256/8118/8118118.png?semt=ais_hybrid"),
                              _buildCategoryButton(context, Icons.business, 'Business & Finance',
                                  "https://cdn-icons-png.flaticon.com/512/444/444899.png"),
                              _buildCategoryButton(context, Icons.library_books, 'Periodicals',
                                  "https://cdn-icons-png.flaticon.com/512/3066/3066332.png"),
                              _buildCategoryButton(context, Icons.favorite, 'Romance',
                                  "https://cdn-icons-png.flaticon.com/512/3669/3669682.png"),
                              _buildCategoryButton(context, Icons.science, 'Science',
                                  "https://cdn-icons-png.freepik.com/256/2022/2022299.png?semt=ais_hybrid"),
                              _buildCategoryButton(context, Icons.history, 'History',
                                  "https://cdn-icons-png.flaticon.com/512/2234/2234770.png"),
                              _buildCategoryButton(context, Icons.psychology, 'Psychology',
                                  "https://www.clipartmax.com/png/small/138-1386070_psychology-icon-blue-psychology-icon.png"),
                              _buildCategoryButton(context, Icons.travel_explore, 'Travel',
                                  "https://cdn-icons-png.flaticon.com/512/201/201623.png"),
                              _buildCategoryButton(context, Icons.home, 'Biography & Memoir',
                                  "https://cdn1.iconfinder.com/data/icons/literary-genres-color/64/biography-life-story-writer-memoir-history-512.png"),
                              _buildCategoryButton(context, Icons.book, 'Non-Fiction',
                                  "https://cdn-icons-png.freepik.com/256/8118/8118118.png?semt=ais_hybrid"),
                              _buildCategoryButton(context, Icons.business, 'Business & Finance',
                                  "https://cdn-icons-png.flaticon.com/512/444/444899.png"),
                              _buildCategoryButton(context, Icons.library_books, 'Periodicals',
                                  "https://cdn-icons-png.flaticon.com/512/3066/3066332.png"),
                              _buildCategoryButton(context, Icons.favorite, 'Romance',
                                  "https://cdn-icons-png.flaticon.com/512/3669/3669682.png"),
                              _buildCategoryButton(context, Icons.science, 'Science',
                                  "https://cdn-icons-png.freepik.com/256/2022/2022299.png?semt=ais_hybrid"),
                              _buildCategoryButton(context, Icons.history, 'History',
                                  "https://cdn-icons-png.flaticon.com/512/2234/2234770.png"),
                              _buildCategoryButton(context, Icons.psychology, 'Psychology',
                                  "https://www.clipartmax.com/png/small/138-1386070_psychology-icon-blue-psychology-icon.png"),
                              _buildCategoryButton(context, Icons.travel_explore, 'Travel',
                                  "https://cdn-icons-png.flaticon.com/512/201/201623.png"),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text('Close Drawer', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  static void showCategoriesPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Scroll Down to view all categories',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildCategoryButton(context, Icons.home, 'Biography & Memoir',
                            "https://cdn1.iconfinder.com/data/icons/literary-genres-color/64/biography-life-story-writer-memoir-history-512.png"),
                        _buildCategoryButton(context, Icons.book, 'Non-Fiction',
                            "https://cdn-icons-png.freepik.com/256/8118/8118118.png?semt=ais_hybrid"),
                        _buildCategoryButton(context, Icons.business, 'Business & Finance',
                            "https://cdn-icons-png.flaticon.com/512/444/444899.png"),
                        _buildCategoryButton(context, Icons.library_books, 'Periodicals',
                            "https://cdn-icons-png.flaticon.com/512/3066/3066332.png"),
                        _buildCategoryButton(context, Icons.favorite, 'Romance',
                            "https://cdn-icons-png.flaticon.com/512/3669/3669682.png"),
                        _buildCategoryButton(context, Icons.science, 'Science',
                            "https://cdn-icons-png.freepik.com/256/2022/2022299.png?semt=ais_hybrid"),
                        _buildCategoryButton(context, Icons.history, 'History',
                            "https://cdn-icons-png.flaticon.com/512/2234/2234770.png"),
                        _buildCategoryButton(context, Icons.psychology, 'Psychology',
                            "https://www.clipartmax.com/png/small/138-1386070_psychology-icon-blue-psychology-icon.png"),
                        _buildCategoryButton(context, Icons.travel_explore, 'Travel',
                            "https://cdn-icons-png.flaticon.com/512/201/201623.png"),
                        // Add more categories as needed
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Close', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildCategoryButton(BuildContext context, IconData icon, String label, String iconUrl) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      onPressed: () {
        // Handle category tap
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            height: 50,
            imageUrl: iconUrl,
          ),
          const SizedBox(height: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 80), // Set a max width for the text
            child: Text(
              label,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.center, // Center the text
              overflow: TextOverflow.ellipsis, // Show ellipsis if text overflows
              maxLines: 2, // Allow up to 2 lines of text
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  static PopupMenuItem buildPopupMenuItemWidget(
      BuildContext context, String title, IconData iconData, int position, String path, bool isPushAndPop) {
    return PopupMenuItem(
        onTap: () {
          if (isPushAndPop) {
            Navigator.pushReplacementNamed(context, path);
          } else {
            Navigator.pushNamed(context, path);
          }
        },
        value: position,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                if (isPushAndPop) {
                  Navigator.pushReplacementNamed(context, path);
                } else {
                  Navigator.pushNamed(context, path);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    iconData,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Text(title)
                ],
              ),
            ),
          ],
        ));
  }

  //AppBar

  static Widget customAppBar(BuildContext context, bool centerTitle, String title, bool isSignUp, bool isSignIn) {
    var appBarHeight = AppBar().preferredSize.height;
    return AppBar(
      backgroundColor: AppColor.appBarBackgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      leading: Responsive.isMobile(context)
          ? IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => AppConstants.openBottomDrawer(context),
            )
          : null,
      title: Text(
        Responsive.isDesktop(context) || Responsive.isTablet(context) ? "Ebook Reader" : title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (Responsive.isDesktop(context) || Responsive.isTablet(context))
          TextButton(
            onPressed: () => AppConstants.showCategoriesPopup(context),
            child: const Text('Categories', style: TextStyle(color: Colors.black, fontSize: 18)),
          ),
        if (Responsive.isDesktop(context) || Responsive.isTablet(context))
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: VerticalDivider(
              color: Colors.grey,
            ),
          ),
        Builder(
          builder: (BuildContext newContext) {
            return IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, AppRouteNames.cartScreen);
              },
            );
          },
        ),
        if (Responsive.isDesktop(context) || Responsive.isTablet(context))
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: VerticalDivider(
              color: Colors.grey,
            ),
          ),
        Responsive.isMobile(context)
            ? PopupMenuButton(
                icon: const Icon(Icons.account_circle_rounded),
                elevation: 10,
                iconColor: Colors.black,
                onSelected: (value) {
                  // onMenuItemSelected(value as int);
                },
                offset: Offset(0.0, appBarHeight),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                itemBuilder: (ctx) => [
                  if (!isSignIn && isSignUp)
                    AppConstants.buildPopupMenuItemWidget(
                        context, "SignIn", Icons.login_rounded, Options.search.index, AppRouteNames.signInRoute, true),
                  if (isSignIn && !isSignUp)
                    AppConstants.buildPopupMenuItemWidget(
                        context, "SignUp", Icons.add_rounded, Options.share.index, AppRouteNames.signUpRoute, true),
                  if (!isSignIn && !isSignUp)
                    AppConstants.buildPopupMenuItemWidget(
                        context, "SignIn", Icons.login_rounded, Options.search.index, AppRouteNames.signInRoute, false),
                  if (!isSignIn && !isSignUp)
                    AppConstants.buildPopupMenuItemWidget(
                        context, "SignUp", Icons.add_rounded, Options.share.index, AppRouteNames.signUpRoute, false),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!isSignIn && !isSignUp) {
                          Navigator.pushNamed(context, AppRouteNames.signInRoute);
                        }
                        if (!isSignIn) {
                          Navigator.pushNamed(context, AppRouteNames.signInRoute);
                        }
                      },
                      child: Text(
                        "Signin",
                        style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSignIn ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: VerticalDivider(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!isSignIn && !isSignUp) {
                          Navigator.pushNamed(context, AppRouteNames.signUpRoute);
                        }
                        if (!isSignUp) {
                          Navigator.pushReplacementNamed(context, AppRouteNames.signUpRoute);
                        }
                      },
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSignUp ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
