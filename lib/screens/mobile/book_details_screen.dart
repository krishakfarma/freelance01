// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook_reader/Document-View-Idea/show_epub.dart';
import 'package:ebook_reader/services/providers/books_provider.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:ebook_reader/services/models/book_model.dart';
import 'package:ebook_reader/services/routing/app_routes_constants.dart';
import 'package:ebook_reader/utils/colors.dart';
import 'package:ebook_reader/utils/constants.dart';
import 'package:ebook_reader/utils/responsive.dart';
import 'package:ebook_reader/utils/styles.dart';
import 'package:ebook_reader/widgets/home_screen_widgets/book_card_widget.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;
  final List<Book> relatedBooks;

  const BookDetailsScreen({
    Key? key,
    required this.book,
    required this.relatedBooks,
  }) : super(key: key);

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool isExpanded = false;

  static Future<void> openURLBook(
      {required String urlPath,
      required BuildContext context,
      Color accentColor = Colors.indigoAccent,
      Function(int currentPage, int totalPages)? onPageFlip,
      Function(int lastPageIndex)? onLastPage,
      required String bookId,
      String chapterListTitle = 'Table of Contents',
      bool shouldOpenDrawer = false,
      int starterChapter = -1}) async {
    final result = await http.get(Uri.parse(urlPath));
    final bytes = result.bodyBytes;
    EpubBook epubBook = await EpubReader.readBook(
      bytes.buffer.asUint8List(),
    );

    if (!context.mounted) return;
    _openBook(
      context: context,
      epubBook: epubBook,
      bookId: bookId,
      shouldOpenDrawer: shouldOpenDrawer,
      starterChapter: starterChapter,
      chapterListTitle: chapterListTitle,
      onPageFlip: onPageFlip,
      onLastPage: onLastPage,
      accentColor: accentColor,
    );
  }

  static _openBook({
    required BuildContext context,
    required EpubBook epubBook,
    required String bookId,
    required bool shouldOpenDrawer,
    required Color accentColor,
    required int starterChapter,
    required String chapterListTitle,
    Function(int currentPage, int totalPages)? onPageFlip,
    Function(int lastPageIndex)? onLastPage,
  }) async {
    ///Set starter chapter as current
    BooksProvider booksProvider = Provider.of<BooksProvider>(context, listen: false);
    booksProvider.epubLoading();
    var route = MaterialPageRoute(
      builder: (context) {
        return EPUBShow(
          epubBook: epubBook,
          starterChapter: 0,
          shouldOpenDrawer: shouldOpenDrawer,
          bookId: bookId,
          accentColor: accentColor,
          chapterListTitle: chapterListTitle,
          onPageFlip: onPageFlip,
          onLastPage: onLastPage,
        );
      },
    );

    Navigator.push(context, route);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   shouldOpenDrawer != false || starterChapter != -1
    //       ? Navigator.pushReplacement(
    //           context,
    //           route,
    //         )
    //       : Navigator.push(
    //           context,
    //           route,
    //         );
    // });
  }

  lateFuture() {
    setState(() {
      openURLBook(urlPath: widget.book.link, context: context, bookId: widget.book.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    BooksProvider b = Provider.of<BooksProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColor.appBarBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Responsive.isDesktop(context) || Responsive.isTablet(context)
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Book Image on the left
                        CachedNetworkImage(
                          imageUrl: widget.book.coverImageLink,
                          height: 400,
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 24), // Spacing between image and content
                        // Book details on the right
                        Expanded(
                          child: _buildBookDetails(),
                        ),
                      ],
                    )
                  : _buildBookDetails(), // For mobile layout, keep the default layout
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 90,
              decoration: const BoxDecoration(
                color: AppColor.whiteColor,
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.book.price == null ? "Free" : "₹ ${widget.book.price!}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.book.type == FileType.PDF) {
                          Navigator.pushNamed(
                            context,
                            AppRouteNames.pdfViewerRoute,
                            arguments: {
                              'title': widget.book.title,
                              'id': widget.book.id,
                              'link': widget.book.link,
                            },
                          );
                        } else {
                          lateFuture();
                          // Navigator.pushNamed(context, AppRouteNames.epubViewerRoute,
                          //     arguments: {"url": widget.book.link, "id": widget.book.id});
                        }
                      },
                      child: Container(
                        height: 55,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColor.mainOrangeColor,
                        ),
                        child: Center(
                          child: Text(
                            widget.book.price == null ? "Read Book" : "Add to cart",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show the image only for mobile, not for tablet and desktop
        if (Responsive.isMobile(context))
          Center(
            child: CachedNetworkImage(
              imageUrl: widget.book.coverImageLink,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(height: 16),
        Text(
          widget.book.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'By ${widget.book.author.name}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        const Text(
          "About the book",
          style: AppStyles.boldText18,
        ),
        const SizedBox(height: 8),
        Text(
          isExpanded || widget.book.description.length <= 100
              ? widget.book.description
              : "${widget.book.description.substring(0, 100)}...",
          style: TextStyle(
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.justify,
        ),
        if (widget.book.description.length > 100)
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? "See Less" : "See More",
              style: const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(height: 16),
        if (Responsive.isMobile(context))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Information",
                style: AppStyles.boldText18,
              ),
              const InformationCard(language: "English", rating: "3.4"),
              const SizedBox(height: 16),
              const Text(
                "About author",
                style: AppStyles.boldText18,
              ),
              AboutAuthorCard(
                author: widget.book.author,
              ),
            ],
          ),
        if (Responsive.isDesktop(context) || Responsive.isTablet(context))
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Information",
                      style: AppStyles.boldText18,
                    ),
                    InformationCard(language: "English", rating: "3.4"),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "About author",
                      style: AppStyles.boldText18,
                    ),
                    AboutAuthorCard(
                      author: widget.book.author,
                    ),
                  ],
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
        const Text(
          "Related books",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.isMobile(context)
                ? 2
                : Responsive.isTablet(context)
                    ? 4
                    : 6,
            childAspectRatio: Responsive.isDesktop(context) ? 0.7 : 0.8, // Adjusted aspect ratio for desktop
            mainAxisSpacing: 15.h,
            crossAxisSpacing: 15.w,
          ),
          itemCount: widget.relatedBooks.length,
          itemBuilder: (context, index) {
            return BookCard(
              onTap: () {},
              title: widget.relatedBooks[index].title,
              author: widget.relatedBooks[index].author.name,
              imageUrl: widget.relatedBooks[index].coverImageLink,
              price: widget.book.price,
            );
          },
        ),
      ],
    );
  }
}

class InformationCard extends StatelessWidget {
  final String language;
  final String rating;

  const InformationCard({
    Key? key,
    required this.language,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set a fixed height for desktop and tablet modes
    double? cardHeight = (Responsive.isDesktop(context) || Responsive.isTablet(context)) ? 90 : null;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: cardHeight, // Apply fixed height for desktop/tablet
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Set spacing based on the available width
            double spacing = constraints.maxWidth > 400 ? 90 : 40;

            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Language",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      language,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(width: spacing),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rating",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star_rate_rounded, size: 25, color: AppColor.mainOrangeColor),
                        Text(
                          rating,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AboutAuthorCard extends StatelessWidget {
  final Author author;

  const AboutAuthorCard({
    Key? key,
    required this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set a fixed height for desktop and tablet modes
    double? cardHeight = (Responsive.isDesktop(context) || Responsive.isTablet(context)) ? 90 : null;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: cardHeight, // Apply fixed height for desktop/tablet
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(author.profileImageUrl ?? AppConstants.userIconLink),
              radius: 30,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.info_outline),
          ],
        ),
      ),
    );
  }
}
