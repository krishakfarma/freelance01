import 'package:ebook_reader/services/providers/books_provider.dart';
import 'package:ebook_reader/utils/responsive.dart';
import 'package:flutter_html_reborn/flutter_html_reborn.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:ebook_reader/Document-View-Idea/Helpers/context_extensions.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart';
import 'package:ebook_reader/Document-View-Idea/Model/book_progress_singleton.dart';
import 'package:ebook_reader/Document-View-Idea/page_flip/pagination.dart';
import 'package:provider/provider.dart';
import 'package:zoom_widget/zoom_widget.dart';

import 'Component/constants.dart';
import 'Component/circle_button.dart';
import 'Component/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

late BookProgressSingleton bookProgress;

const double DESIGN_WIDTH = 375;
const double DESIGN_HEIGHT = 812;

String selectedFont = 'Segoe';
List<String> fontNames = [
  "Segoe",
];

class CustomToast {
  static void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

Snack(String msg, BuildContext ctx, Color color) {
  var snackBar = SnackBar(
      backgroundColor: color,
      content: Text(
        msg,
        textAlign: TextAlign.center,
      ));
  ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
}

Color backColor = Colors.white;
Color fontColor = Colors.black;
int staticThemeId = 3;

class LocalChapterModel {
  final String chapter;
  bool isSubChapter = false;

  LocalChapterModel({required this.chapter, required this.isSubChapter});
}

// ignore: must_be_immutable
class EPUBShow extends StatefulWidget {
  EpubBook epubBook;
  bool shouldOpenDrawer;
  int starterChapter;
  final String bookId;
  final String chapterListTitle;
  final Function(int currentPage, int totalPages)? onPageFlip;
  final Function(int lastPageIndex)? onLastPage;
  final Color accentColor;

  EPUBShow({
    super.key,
    required this.epubBook,
    required this.accentColor,
    this.starterChapter = 0,
    this.shouldOpenDrawer = false,
    required this.bookId,
    required this.chapterListTitle,
    this.onPageFlip,
    this.onLastPage,
  });

  @override
  State<StatefulWidget> createState() => EPUBShowState();
}

class EPUBShowState extends State<EPUBShow> {
  String htmlContent = '';
  String? innerHtmlContent;
  String textContent = '';
  bool showBrightnessWidget = false;
  final controller = ScrollController();
  Future<void> loadChapterFuture = Future.value(true);
  List<LocalChapterModel> chaptersList = [];
  double _fontSizeProgress = 17.0;
  double _fontSize = 17.0;

  late EpubBook epubBook;
  late String bookId;
  String bookTitle = '';
  String chapterTitle = '';
  double brightnessLevel = 0.5;

  late String selectedTextStyle;

  bool showHeader = true;
  bool isLastPage = false;
  int lastSwipe = 0;
  int prevSwipe = 0;
  bool showPrevious = false;
  bool showNext = false;

  GetStorage gs = GetStorage();

  PagingTextHandler controllerPaging = PagingTextHandler(paginate: () {});

  @override
  void initState() {
    loadThemeSettings();
    BooksProvider booksProvider = Provider.of<BooksProvider>(context, listen: false);
    booksProvider.epubLoaded();
    bookId = widget.bookId;
    epubBook = widget.epubBook;
    // allFonts = GoogleFonts.asMap().cast<String, String>();
    // fontNames = allFonts.keys.toList();
    // selectedTextStyle = GoogleFonts.getFont(selectedFont).fontFamily!;
    selectedTextStyle = fontNames.where((element) => element == selectedFont).first;

    getTitleFromXhtml();
    reLoadChapter(init: true);

    super.initState();
  }

  loadThemeSettings() {
    selectedFont = gs.read(libFont) ?? selectedFont;
    var themeId = gs.read(libTheme) ?? staticThemeId;
    updateTheme(themeId, isInit: true);
    _fontSize = gs.read(libFontSize) ?? _fontSize;
    _fontSizeProgress = _fontSize;
  }

  getTitleFromXhtml() {
    if (epubBook.Title != null) {
      bookTitle = epubBook.Title!;
      updateUI();
    }
  }

  reLoadChapter({bool init = false, int index = -1}) async {
    int currentIndex = bookProgress.getBookProgress(bookId).currentChapterIndex;

    setState(() {
      loadChapterFuture = loadChapter(
        index: init
            ? -1
            : index == -1
                ? currentIndex
                : index,
      );
    });
  }

  loadChapter({int index = -1}) async {
    chaptersList = [];

    await Future.wait(epubBook.Chapters!.map((EpubChapter chapter) async {
      String? chapterTitle = chapter.Title;
      List<LocalChapterModel> subChapters = [];
      for (var element in chapter.SubChapters!) {
        subChapters.add(LocalChapterModel(chapter: element.Title!, isSubChapter: true));
      }

      chaptersList.add(LocalChapterModel(chapter: chapterTitle ?? '...', isSubChapter: false));

      chaptersList += subChapters;
    }));

    ///Choose initial chapter
    if (widget.starterChapter >= 0 && widget.starterChapter < chaptersList.length) {
      setupNavButtons();
      await updateContentAccordingChapter(index == -1 ? widget.starterChapter : index);
    } else {
      setupNavButtons();
      await updateContentAccordingChapter(0);
      CustomToast.showToast("Invalid chapter number. Range [0-${chaptersList.length}]");
    }
  }

  updateContentAccordingChapter(int chapterIndex) async {
    ///Set current chapter index
    await bookProgress.setCurrentChapterIndex(bookId, chapterIndex);

    String content = '';

    await Future.wait(epubBook.Chapters!.map((EpubChapter chapter) async {
      content = epubBook.Chapters![chapterIndex].HtmlContent!;

      List<EpubChapter>? subChapters = chapter.SubChapters;
      if (subChapters != null && subChapters.isNotEmpty) {
        for (int i = 0; i < subChapters.length; i++) {
          content = content + subChapters[i].HtmlContent!;
        }
      } else {
        subChapters?.forEach((element) {
          if (element.Title == epubBook.Chapters![chapterIndex].Title) {
            content = element.HtmlContent!;
          }
        });
      }
    }));

    htmlContent = content;
    textContent = parse(htmlContent).documentElement!.text;

    if (isHTML(textContent)) {
      innerHtmlContent = textContent;
    } else {
      textContent = textContent.replaceAll('Unknown', '').trim();
    }
    controllerPaging.paginate();

    setupNavButtons();
  }

  bool isHTML(String str) {
    final RegExp htmlRegExp = RegExp('<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlRegExp.hasMatch(str);
  }

  setupNavButtons() {
    int index = bookProgress.getBookProgress(bookId).currentChapterIndex;

    setState(() {
      if (index == 0) {
        showPrevious = false;
      } else {
        showPrevious = true;
      }
      if (index == chaptersList.length - 1) {
        showNext = false;
      } else {
        showNext = true;
      }
    });
  }

  Future<bool> backPress() async {
    Navigator.of(context).pop();
    return true;
  }

  updateFontSettings() {
    return showModalBottomSheet(
        context: context,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        backgroundColor: backColor,
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Responsive.isDesktop(context) || Responsive.isTablet(context) ? 20 : 20.r),
                topRight: Radius.circular(20))),
        builder: (context) {
          return SingleChildScrollView(
              child: StatefulBuilder(
                  builder: (BuildContext context, setState) => SizedBox(
                        height: 100.h,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              height: 45.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      updateTheme(1);
                                    },
                                    child: CircleButton(
                                      backColor: cVioletishColor,
                                      fontColor: Colors.black,
                                      id: 1,
                                      accentColor: widget.accentColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isDesktop(context) || Responsive.isTablet(context) ? 10 : 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      updateTheme(2);
                                    },
                                    child: CircleButton(
                                      backColor: cBluishColor,
                                      fontColor: Colors.black,
                                      id: 2,
                                      accentColor: widget.accentColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      updateTheme(3);
                                    },
                                    child: CircleButton(
                                      id: 3,
                                      backColor: Colors.white,
                                      fontColor: Colors.black,
                                      accentColor: widget.accentColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      updateTheme(4);
                                    },
                                    child: CircleButton(
                                      id: 4,
                                      backColor: Colors.black,
                                      fontColor: Colors.white,
                                      accentColor: widget.accentColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      updateTheme(5);
                                    },
                                    child: CircleButton(
                                      id: 5,
                                      backColor: cPinkishColor,
                                      fontColor: Colors.black,
                                      accentColor: widget.accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Divider(
                            //   thickness: 1.h,
                            //   height: 0,
                            //   indent: 0,
                            //   color: Colors.grey,
                            // ),
                            // Expanded(
                            //   child: Container(
                            //       padding: EdgeInsets.symmetric(horizontal: 20.h),
                            //       child: Column(
                            //         children: [
                            //           StatefulBuilder(
                            //             builder: (BuildContext context, StateSetter setState) => Theme(
                            //               data: Theme.of(context).copyWith(canvasColor: backColor),
                            //               child: DropdownButtonHideUnderline(
                            //                 child: DropdownButton<String>(
                            //                     value: selectedFont,
                            //                     isExpanded: true,
                            //                     menuMaxHeight: 400.h,
                            //                     onChanged: (newValue) {
                            //                       setState(() {
                            //                         selectedFont = newValue!;

                            //                         selectedTextStyle =
                            //                             fontNames.where((element) => element == selectedFont).first;
                            //                         print(selectedTextStyle);

                            //                         gs.write(libFont, selectedFont);

                            //                         ///For updating inside
                            //                         setState(() {});
                            //                         controllerPaging.paginate();
                            //                         updateUI();
                            //                       });
                            //                     },
                            //                     items: fontNames.map<DropdownMenuItem<String>>((String font) {
                            //                       return DropdownMenuItem<String>(
                            //                         value: font,
                            //                         child: Text(
                            //                           font,
                            //                           style: TextStyle(
                            //                             color: selectedFont == font ? widget.accentColor : fontColor,
                            //                             fontSize: Responsive.isDesktop(context) ||
                            //                                     Responsive.isTablet(context)
                            //                                 ? 10
                            //                                 : 15.sp,
                            //                             fontWeight:
                            //                                 selectedFont == font ? FontWeight.bold : FontWeight.normal,
                            //                             fontFamily: selectedFont,
                            //                           ),
                            //                         ),
                            //                       );
                            //                     }).toList()),
                            //               ),
                            //             ),
                            //           ),
                            //           Row(
                            //             children: [
                            //               Text(
                            //                 "Aa",
                            //                 style: TextStyle(
                            //                   fontSize: Responsive.isDesktop(context) ? 23 : 15.sp,
                            //                   color: fontColor,
                            //                   fontWeight: FontWeight.bold,
                            //                 ),
                            //               ),
                            //               Expanded(
                            //                 child: Slider(
                            //                   activeColor:
                            //                       staticThemeId == 4 ? Colors.grey.withOpacity(0.8) : Colors.blue,
                            //                   value: _fontSizeProgress,
                            //                   min: 15.0,
                            //                   max: 30.0,
                            //                   onChangeEnd: (double value) {
                            //                     _fontSize = value;

                            //                     gs.write(libFontSize, _fontSize);

                            //                     ///For updating outside
                            //                     updateUI();
                            //                     controllerPaging.paginate();
                            //                   },
                            //                   onChanged: (double value) {
                            //                     ///For updating widget's inside
                            //                     setState(() {
                            //                       _fontSizeProgress = value;
                            //                     });
                            //                   },
                            //                 ),
                            //               ),
                            //               Text(
                            //                 "Aa",
                            //                 style: TextStyle(
                            //                   color: fontColor,
                            //                   fontSize: Responsive.isDesktop(context) ? 23 : 20.sp,
                            //                   fontWeight: FontWeight.bold,
                            //                 ),
                            //               )
                            //             ],
                            //           )
                            //         ],
                            //       )),
                            // ),
                          ],
                        ),
                      )));
        });
  }

  updateTheme(int id, {bool isInit = false}) {
    staticThemeId = id;
    if (id == 1) {
      backColor = cVioletishColor;
      fontColor = Colors.black;
    } else if (id == 2) {
      backColor = cBluishColor;
      fontColor = Colors.black;
    } else if (id == 3) {
      backColor = Colors.white;
      fontColor = Colors.black;
    } else if (id == 4) {
      backColor = Colors.black;
      fontColor = Colors.white;
    } else {
      backColor = cPinkishColor;
      fontColor = Colors.black;
    }

    gs.write(libTheme, id);

    if (!isInit) {
      Navigator.of(context).pop();
      controllerPaging.paginate();
      updateUI();
    }
  }

  ///Update widget tree
  updateUI() {
    setState(() {});
  }

  nextChapter() async {
    ///Set page to initial
    await bookProgress.setCurrentPageIndex(bookId, 0);

    var index = bookProgress.getBookProgress(bookId).currentChapterIndex ?? 0;

    if (index != chaptersList.length - 1) {
      reLoadChapter(index: index + 1);
    }
  }

  prevChapter() async {
    ///Set page to initial
    await bookProgress.setCurrentPageIndex(bookId, 0);

    var index = bookProgress.getBookProgress(bookId).currentChapterIndex ?? 0;

    if (index != 0) {
      reLoadChapter(index: index - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(DESIGN_WIDTH, DESIGN_HEIGHT));
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: backPress,
        child: Scaffold(
          backgroundColor: backColor,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        child: Stack(
                      children: [
                        FutureBuilder<void>(
                            future: loadChapterFuture,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  {
                                    // Otherwise, display a loading indicator.
                                    return Center(
                                        child: CupertinoActivityIndicator(
                                      color: Theme.of(context).primaryColor,
                                      radius: 30.r,
                                    ));
                                  }
                                default:
                                  {
                                    if (widget.shouldOpenDrawer) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        openTableOfContents();
                                      });

                                      widget.shouldOpenDrawer = false;
                                    }

                                    var currentChapterIndex =
                                        bookProgress.getBookProgress(bookId).currentChapterIndex ?? 0;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showHeader = !showHeader;
                                        });
                                      },
                                      child: Center(
                                        child: Responsive.isDesktop(context) || Responsive.isTablet(context)
                                            ? PinchZoomReleaseUnzoomWidget(
                                                minScale: 0.8,
                                                child: content(context, currentChapterIndex),
                                              )
                                            : Zoom(
                                                centerOnScale: false,
                                                maxZoomHeight: height,
                                                maxZoomWidth: 460,
                                                initTotalZoomOut: true,
                                                child: content(context, currentChapterIndex),
                                              ),
                                      ),
                                    );
                                  }
                              }
                            }),
                        //)
                      ],
                    )),
                    AnimatedContainer(
                      height: showHeader ? 40.h : 0,
                      duration: const Duration(milliseconds: 100),
                      color: backColor,
                      child: Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: backColor,
                          border: Border(
                            top: BorderSide(width: 3, color: Colors.orange[200]!),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 5.w,
                            ),
                            Visibility(
                              visible: showPrevious,
                              child: IconButton(
                                  onPressed: () {
                                    prevChapter();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    size: Responsive.isDesktop(context) || Responsive.isTablet(context) ? 15 : 15.h,
                                    color: fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Expanded(
                              flex: 10,
                              child: Text(
                                chaptersList.isNotEmpty
                                    ? chaptersList[bookProgress.getBookProgress(bookId).currentChapterIndex ?? 0]
                                        .chapter
                                    : 'Loading...',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Responsive.isDesktop(context) || Responsive.isTablet(context) ? 13 : 13.sp,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: selectedTextStyle,
                                  package: 'cosmos_epub',
                                  fontWeight: FontWeight.bold,
                                  color: fontColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Visibility(
                                visible: showNext,
                                child: IconButton(
                                    onPressed: () {
                                      nextChapter();
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: Responsive.isDesktop(context) || Responsive.isTablet(context) ? 15 : 15.h,
                                      color: fontColor,
                                    ))),
                            SizedBox(
                              width: 5.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: showHeader
                      ? Responsive.isDesktop(context) || Responsive.isTablet(context)
                          ? 50
                          : 50.h
                      : 0,
                  duration: const Duration(milliseconds: 100),
                  color: backColor,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: Responsive.isDesktop(context) || Responsive.isTablet(context) ? 3 : 3.h),
                    child: AppBar(
                      centerTitle: true,
                      title: Text(
                        bookTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: context.isLargeTablet ? 16 : 16.sp,
                          color: fontColor,
                        ),
                      ),
                      backgroundColor: backColor,
                      shape: Border(bottom: BorderSide(color: Colors.orange[200]!, width: 3)),
                      elevation: 0,
                      leading: IconButton(
                        onPressed: openTableOfContents,
                        icon: Icon(
                          Icons.menu,
                          color: fontColor,
                          size: Responsive.isDesktop(context) || Responsive.isTablet(context) ? 30 : 20.h,
                        ),
                      ),
                      actions: [
                        InkWell(
                            onTap: () {
                              updateFontSettings();
                            },
                            child: Container(
                              width: Responsive.isDesktop(context) || Responsive.isTablet(context) ? 40 : 40.w,
                              alignment: Alignment.center,
                              child: Text(
                                "BG",
                                style: TextStyle(
                                  fontSize: Responsive.isDesktop(context) || Responsive.isDesktop(context) ? 18 : 18.sp,
                                  color: fontColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget content(BuildContext context, int currentChapterIndex) {
    return Container(
      decoration: BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: Colors.black))),
      width: Responsive.isDesktop(context) || Responsive.isTablet(context) ? 700 : double.infinity,
      child: PagingWidget(
        textContent,
        innerHtmlContent,

        ///Do we need this to the production
        lastWidget: null,
        starterPageIndex: bookProgress.getBookProgress(bookId).currentPageIndex ?? 0,
        style: TextStyle(
            backgroundColor: backColor,
            fontSize: Responsive.isDesktop(context) || Responsive.isTablet(context) ? 24 : _fontSize.sp,
            fontFamily: selectedTextStyle,
            package: 'cosmos_epub',
            color: fontColor),
        handlerCallback: (ctrl) {
          controllerPaging = ctrl;
        },
        onTextTap: () {
          if (showHeader) {
            showHeader = false;
          } else {
            showHeader = true;
          }
          updateUI();
        },
        onPageFlip: (currentPage, totalPages) {
          if (widget.onPageFlip != null) {
            widget.onPageFlip!(currentPage, totalPages);
          }

          if (currentPage == totalPages - 1) {
            bookProgress.setCurrentPageIndex(bookId, 0);
          } else {
            bookProgress.setCurrentPageIndex(bookId, currentPage);
          }

          if (isLastPage) {
            showHeader = true;
          } else {
            lastSwipe = 0;
          }

          isLastPage = false;
          updateUI();

          if (currentPage == 0) {
            prevSwipe++;
            if (prevSwipe > 1) {
              prevChapter();
            }
          } else {
            prevSwipe = 0;
          }
        },
        onLastPage: (index, totalPages) async {
          if (widget.onLastPage != null) {
            widget.onLastPage!(index);
          }

          if (totalPages > 1) {
            lastSwipe++;
          } else {
            lastSwipe = 2;
          }

          if (lastSwipe > 1) {
            nextChapter();
          }

          isLastPage = true;

          updateUI();
        },
        chapterTitle: chaptersList[currentChapterIndex].chapter,
        totalChapters: chaptersList.length,
      ),
    );
  }

  openTableOfContents() async {
    bool? shouldUpdate = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChaptersList(
                  bookId: bookId,
                  chapters: chaptersList,
                  leadingIcon: null,
                  accentColor: widget.accentColor,
                  chapterListTitle: widget.chapterListTitle,
                ))) ??
        false;
    if (shouldUpdate) {
      var index = bookProgress.getBookProgress(bookId).currentChapterIndex ?? 0;

      ///Set page to initial and update chapter index with content
      await bookProgress.setCurrentPageIndex(bookId, 0);
      reLoadChapter(index: index);
    }
  }
}

// ignore: must_be_immutable

// ignore: must_be_immutable
class ChaptersList extends StatelessWidget {
  List<LocalChapterModel> chapters = [];
  final String bookId;
  final Widget? leadingIcon;
  final Color accentColor;
  final String chapterListTitle;

  ChaptersList(
      {super.key,
      required this.chapters,
      required this.bookId,
      this.leadingIcon,
      required this.accentColor,
      required this.chapterListTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.h,
        backgroundColor: backColor,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop(false);
            },
            child: Icon(
              Icons.close,
              color: fontColor,
              size: 20.h,
            )),
        centerTitle: true,
        title: Text(
          chapterListTitle,
          style: TextStyle(fontWeight: FontWeight.bold, color: accentColor, fontSize: 15.sp),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: backColor,
          padding: EdgeInsets.all(10.h),
          child: ListView.builder(
              itemCount: chapters.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () async {
                        await bookProgress.setCurrentChapterIndex(bookId, i);
                        Navigator.of(context).pop(true);
                      },
                      leading: leadingIcon,
                      minLeadingWidth: 20.w,
                      title: Padding(
                        padding: EdgeInsets.only(left: chapters[i].isSubChapter ? 15.w : 0),
                        child: Text(chapters[i].chapter,
                            style: TextStyle(
                                color: bookProgress.getBookProgress(bookId).currentChapterIndex == i
                                    ? accentColor
                                    : fontColor,
                                fontFamily: fontNames.where((element) => element == selectedFont).first,
                                package: 'cosmos_epub',
                                fontSize: 15.sp,
                                fontWeight: chapters[i].isSubChapter ? FontWeight.w400 : FontWeight.w600)),
                      ),
                      dense: true,
                    ),
                    Divider(height: 0, thickness: 1.h),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
