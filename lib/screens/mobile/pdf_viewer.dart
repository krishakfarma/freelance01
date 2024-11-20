// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:ebook_reader/utils/colors.dart';
import 'package:ebook_reader/widgets/global/elevated_circular_icon.dart';

// ignore: must_be_immutable
class PdfViewerScreen extends StatefulWidget {
  String pdfLink;
  String title;
  String id;
  PdfViewerScreen({
    Key? key,
    required this.pdfLink,
    required this.title,
    required this.id,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfViewerController _pdfViewerController;
  late PdfTextSearchResult _searchResult;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _totalSearchCount = 0;
  int _currentPageNumber = 1;
  late String _pdfTitle;
  late String lastPageKey;

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pdfTitle = widget.title;
    lastPageKey = widget.id;
    _pdfViewerController = PdfViewerController();
    _searchResult = PdfTextSearchResult();
    // detail.
    _pdfViewerController.annotationSettings.highlight.color = Colors.black;

    _searchController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchText(_searchController.text);
      });
    });

    _loadLastViewedPage();
  }

  void saveGlobalKeyData() {
    GlobalKey<SfPdfViewerState> _newKey = GlobalKey();
    _newKey = _pdfViewerKey;

    bool ans = _newKey.currentContext == _pdfViewerKey.currentContext;

    print("-----------------------------------------------------");
    print(ans);
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    _searchController.dispose();
    saveGlobalKeyData();
    super.dispose();
  }

  Future<void> _loadLastViewedPage() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPage = prefs.getInt(lastPageKey) ?? 0;

    if (lastPage > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pdfViewerController.jumpToPage(lastPage);
      });
    }
  }

  void _saveLastViewedPage(int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(lastPageKey, pageNumber);
  }

  void _searchText(String text) async {
    if (text.isEmpty) {
      setState(() {
        _totalSearchCount = 0;
        _searchResult.clear();
      });
    } else {
      _pdfViewerController.clearSelection();
      _searchResult = _pdfViewerController.searchText(text);

      _searchResult.addListener(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _totalSearchCount = _searchResult.totalInstanceCount;
          });
        });
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _totalSearchCount = 0;
        _searchController.clear();
        _searchResult.clear();
      }
    });
  }

  void _goToNextPage() {
    if (_currentPageNumber < (_pdfViewerController.pageCount)) {
      _pdfViewerController.nextPage();
      _generatePageWidgets();
    }
  }

  void _goToPreviousPage() {
    if (_currentPageNumber > 1) {
      _pdfViewerController.previousPage();
    }
  }

  void changePage(int newPage) {
    setState(() {
      _currentPageNumber = newPage;
    });
  }

  bool _isFullScreen = false;
  void toggleFullScreenMode() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: ,
      appBar: !_isFullScreen
          ? AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              title: _isSearching
                  ? TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search in PDF...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                      style: const TextStyle(color: Colors.black),
                    )
                  : Text(
                      _pdfTitle,
                      style: const TextStyle(color: Colors.black),
                    ),
              actions: <Widget>[
                if (!_isSearching)
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: _toggleSearch,
                  ),
                if (_isSearching)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_up, color: Colors.black),
                        onPressed: () {
                          _searchResult.previousInstance();
                        },
                      ),
                      Text(
                        '$_totalSearchCount',
                        style: const TextStyle(color: Colors.black),
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                        onPressed: () {
                          _searchResult.nextInstance();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: _toggleSearch,
                      ),
                    ],
                  ),
              ],
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SfPdfViewer.network(
              widget.pdfLink,
              key: _pdfViewerKey,
              onTap: (details) {
                toggleFullScreenMode();
              },
              onTextSelectionChanged: (details) {},
              controller: _pdfViewerController,
              enableDoubleTapZooming: true,
              enableDocumentLinkAnnotation: false,
              pageLayoutMode: PdfPageLayoutMode.continuous,
              scrollDirection: PdfScrollDirection.horizontal,
              currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.6),
              otherSearchTextHighlightColor: Colors.yellow.withOpacity(0.3),
              onPageChanged: (PdfPageChangedDetails details) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  changePage(details.newPageNumber);
                  _saveLastViewedPage(details.newPageNumber);
                });
              },
            ),
          ),
          if (!_isFullScreen)
            Padding(
              padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedCircularIconWidget(
                          onPressed: _goToPreviousPage,
                          icon: Icons.arrow_back_ios_new_rounded,
                        ),
                        Text(
                          'Page $_currentPageNumber / ${_pdfViewerController.pageCount}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        ElevatedCircularIconWidget(
                          onPressed: _goToNextPage,
                          icon: Icons.arrow_forward_ios_rounded,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(12),
                    minHeight: 6,
                    value: (_pdfViewerController.pageCount) > 0
                        ? _currentPageNumber / (_pdfViewerController.pageCount)
                        : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColor.mainOrangeColor),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<List<Widget>> _generatePageWidgets() async {
    List<Widget> pageWidgets = [];
    for (int i = 1; i <= _pdfViewerController.pageCount; i++) {
      pageWidgets.add(
        SfPdfViewer.network(
          widget.pdfLink,
          key: _pdfViewerKey,
          onTap: (details) {
            toggleFullScreenMode();
          },
          onTextSelectionChanged: (details) {},
          controller: _pdfViewerController,
          enableDoubleTapZooming: true,
          enableDocumentLinkAnnotation: false,
          pageLayoutMode: PdfPageLayoutMode.continuous,
          scrollDirection: PdfScrollDirection.horizontal,
          currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.6),
          otherSearchTextHighlightColor: Colors.yellow.withOpacity(0.3),
          onPageChanged: (PdfPageChangedDetails details) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              changePage(details.newPageNumber);
              _saveLastViewedPage(details.newPageNumber);
            });
          },
        ),
      );
    }

    print(pageWidgets.length);
    return pageWidgets;
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPageNumber = newPage;
    });
    _saveLastViewedPage(newPage);
  }
}
