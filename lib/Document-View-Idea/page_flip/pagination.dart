import 'dart:ui';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_reborn/flutter_html_reborn.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ebook_reader/Document-View-Idea/page_flip/page_flip_widget.dart';

class PagingTextHandler {
  final Function paginate;

  PagingTextHandler({required this.paginate}); // will point to widget show method
}

class PagingWidget extends StatefulWidget {
  final String textContent;
  final String? innerHtmlContent;
  final String chapterTitle;
  final int totalChapters;
  final int starterPageIndex;
  final TextStyle style;
  final Function handlerCallback;
  final VoidCallback onTextTap;
  final Function(int, int) onPageFlip;
  final Function(int, int) onLastPage;
  final Widget? lastWidget;

  const PagingWidget(
    this.textContent,
    this.innerHtmlContent, {
    super.key,
    this.style = const TextStyle(
      color: Colors.black,
      fontSize: 30,
    ),
    required this.handlerCallback(PagingTextHandler handler),
    required this.onTextTap,
    required this.onPageFlip,
    required this.onLastPage,
    this.starterPageIndex = 0,
    required this.chapterTitle,
    required this.totalChapters,
    this.lastWidget,
  });

  @override
  _PagingWidgetState createState() => _PagingWidgetState();
}

class _PagingWidgetState extends State<PagingWidget> {
  final List<String> _pageTexts = [];
  List<Widget> pages = [];
  int _currentPageIndex = 0;
  Future<void> paginateFuture = Future.value(true);
  late RenderBox _initializedRenderBox;
  Widget? lastWidget;

  final _pageKey = GlobalKey();
  final _pageController = GlobalKey<PageFlipWidgetState>();

  @override
  void initState() {
    rePaginate();
    var handler = PagingTextHandler(paginate: rePaginate);
    widget.handlerCallback(handler); // callback call.
    super.initState();
  }

  rePaginate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _initializedRenderBox = context.findRenderObject() as RenderBox;
        paginateFuture = _paginate();
      });
    });
  }

  int findLastHtmlTagIndex(String input) {
    // Regular expression pattern to match HTML tags
    RegExp regex = RegExp(r'<[^>]');

    // Find all matches
    Iterable<Match> matches = regex.allMatches(input);

    // If matches are found
    if (matches.isNotEmpty) {
      // Return the end index of the last match
      return matches.last.end;
    } else {
      // If no match is found, return -1
      return -1;
    }
  }

  Future<void> _paginate() async {
    final pageSize = _initializedRenderBox.size;

    _pageTexts.clear();

    final textSpan = TextSpan(
      text: widget.textContent,
      style: widget.style,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: pageSize.width,
    );

    // https://medium.com/swlh/flutter-line-metrics-fd98ab180a64
    List<LineMetrics> lines = textPainter.computeLineMetrics();
    double currentPageBottom = pageSize.height;
    int currentPageStartIndex = 0;
    int currentPageEndIndex = 0;

    await Future.wait(lines.map((line) async {
      final left = line.left;
      final top = line.baseline - line.ascent;
      final bottom = line.baseline + line.descent;

      var innerHtml = widget.innerHtmlContent;

      // Current line overflow page
      if (currentPageBottom < bottom) {
        currentPageEndIndex =
            textPainter.getPositionForOffset(Offset(left, top - (innerHtml != null ? 0 : 100.h))).offset;

        var pageText = widget.textContent.substring(currentPageStartIndex, currentPageEndIndex);

        var index = findLastHtmlTagIndex(pageText) + currentPageStartIndex;

        /// Offset to the left from last HTML tag
        if (index != -1) {
          int difference = currentPageEndIndex - index;
          if (difference < 4) {
            currentPageEndIndex = index - 2;
          }

          pageText = widget.textContent.substring(currentPageStartIndex, currentPageEndIndex);
          // print('start : $currentPageStartIndex');
          // print('end : $currentPageEndIndex');
          // print('last html tag : $index');
        }

        _pageTexts.add(pageText);

        currentPageStartIndex = currentPageEndIndex;
        currentPageBottom = top + pageSize.height - (innerHtml != null ? 120.h : 150.h);
      }
    }));
    List<Widget> toolbarActionList(EditableTextState state, onTap) {
      return [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Highlight"),
          ),
        )
      ];
    }

    final lastPageText = widget.textContent.substring(currentPageStartIndex);
    _pageTexts.add(lastPageText);
    final TextEditingController _controller = TextEditingController();
    // Assuming each operation within the loop is asynchronous and returns a Future
    List<Future<Widget>> futures = _pageTexts.map((text) async {
      TextSelection? currentSelection;
      final List<TextRange> highlightedRanges = [];
      List<TextSpan> buildSpans() {
        final List<TextSpan> spans = [];
        int startIndex = 0;

        for (final range in highlightedRanges) {
          if (range.start > startIndex) {
            spans.add(TextSpan(
              text: text.substring(startIndex, range.start),
              style: const TextStyle(color: Colors.black),
            ));
          }

          spans.add(TextSpan(
            text: text.substring(range.start, range.end),
            style: const TextStyle(
              backgroundColor: Colors.yellow,
              color: Colors.black,
            ),
          ));

          startIndex = range.end;
        }

        if (startIndex < text.length) {
          spans.add(TextSpan(
            text: text.substring(startIndex),
            style: const TextStyle(color: Colors.black),
          ));
        }

        return spans;
      }

      /// Adds a new highlight range to the list
      void _highlightSelection() {
        print("sahil");
        print(currentSelection);
        if (currentSelection == null || currentSelection!.isCollapsed) return;

        final start = currentSelection!.start;
        final end = currentSelection!.end;

        // Avoid adding duplicate ranges
        if (!highlightedRanges.any((range) => range.start == start && range.end == end)) {
          setState(() {
            highlightedRanges.add(TextRange(start: start, end: end));
            highlightedRanges.sort((a, b) => a.start.compareTo(b.start));
          });
        }
      }

      final _scrollController = ScrollController();
      return InkWell(
        onTap: widget.onTextTap,
        child: Container(
          color: widget.style.backgroundColor,
          child: FadingEdgeScrollView.fromSingleChildScrollView(
            gradientFractionOnEnd: 0.2,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(bottom: 40.h, top: 60.h, left: 10.w, right: 10.w),
                child:
                    // widget.innerHtmlContent != null
                    GestureDetector(
                  onTap: _highlightSelection,
                  child: SelectableText.rich(
                    TextSpan(children: buildSpans()),
                    showCursor: false,
                    cursorColor: Colors.blue,
                    cursorWidth: 2.0,
                    onSelectionChanged: (selection, cause) {
                      setState(() {
                        currentSelection = selection;
                      });
                    },
                    contextMenuBuilder: (_, EditableTextState state) {
                      return AdaptiveTextSelectionToolbar(
                          anchors: state.contextMenuAnchors,
                          children: toolbarActionList(state, () {
                            _highlightSelection();
                          }));
                    },
                  ),
                ),

                // SelectableText(
                //     text,
                //     textAlign: TextAlign.justify,
                //     style: widget.style,
                //     // overflow: TextOverflow.visible,
                //   ),
              ),
            ),
          ),
        ),
      );
    }).toList();

    pages = await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: paginateFuture,
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
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: SizedBox.expand(
                            key: _pageKey,
                            child: PageFlipWidget(
                              key: _pageController,
                              initialIndex: widget.starterPageIndex != 0
                                  ? (pages.isNotEmpty && widget.starterPageIndex < pages.length
                                      ? widget.starterPageIndex
                                      : 0)
                                  : widget.starterPageIndex,
                              onPageFlip: (pageIndex) {
                                _currentPageIndex = pageIndex;
                                widget.onPageFlip(pageIndex, pages.length);
                                if (_currentPageIndex == pages.length - 1) {
                                  widget.onLastPage(pageIndex, pages.length);
                                }
                              },
                              backgroundColor: widget.style.backgroundColor ?? Colors.white,
                              lastPage: widget.lastWidget,
                              children: pages,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.first_page),
                                onPressed: () {
                                  setState(() {
                                    _currentPageIndex = 0;
                                    _pageController.currentState?.goToPage(_currentPageIndex);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.navigate_before),
                                onPressed: () {
                                  setState(() {
                                    if (_currentPageIndex > 0) _currentPageIndex--;
                                    _pageController.currentState?.goToPage(_currentPageIndex);
                                  });
                                },
                              ),
                              Text(
                                '${_currentPageIndex + 1}/${_pageTexts.length}',
                              ),
                              IconButton(
                                icon: Icon(Icons.navigate_next),
                                onPressed: () {
                                  setState(() {
                                    if (_currentPageIndex < _pageTexts.length - 1) _currentPageIndex++;
                                    _pageController.currentState?.goToPage(_currentPageIndex);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.last_page),
                                onPressed: () {
                                  setState(() {
                                    _currentPageIndex = _pageTexts.length - 1;
                                    _pageController.currentState?.goToPage(_currentPageIndex);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
          }
        });
  }
}
