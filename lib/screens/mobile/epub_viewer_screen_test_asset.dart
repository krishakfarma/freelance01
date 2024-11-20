// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class Highlight {
  final int chapterIndex;
  final int pageIndex;
  final int startIndex;
  final int endIndex;

  Highlight({
    required this.chapterIndex,
    required this.pageIndex,
    required this.startIndex,
    required this.endIndex,
  });
}

// ignore: must_be_immutable
class EpubViewer extends StatefulWidget {
  String url;
  String id;
  EpubViewer({
    Key? key,
    required this.url,
    required this.id,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EpubViewerState createState() => _EpubViewerState();
}

class _EpubViewerState extends State<EpubViewer> {
  EpubBook? _epubBook;
  List<EpubChapter>? _chapters;
  int _currentChapter = 0;
  int _currentPage = 0; // Track the current page
  late PageController _pageController;
  List<List<String>> _chapterPages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _loadEPUB();
    _loadProgress();
  }

  // Load the book from the URL
  Future<void> _loadEPUB() async {
    try {
      String url = widget.url;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        final epubBook = await EpubReader.readBook(bytes);
        setState(() {
          _epubBook = epubBook;
          _chapters = epubBook.Chapters;
          if (_chapters != null && _chapters!.isNotEmpty) {
            _chapterPages = _splitChapterContentIntoPages();
          }
        });
      }
    } catch (e) {
      debugPrint('Failed to load EPUB: $e');
    }
  }

  // Split chapter content into pages based on screen width
  List<List<String>> _splitChapterContentIntoPages() {
    List<List<String>> chapterPages = [];
    double screenWidth = MediaQuery.of(context).size.width;

    int maxContentLength = screenWidth > 800 ? 4000 : 1500;

    for (var chapter in _chapters!) {
      var content = chapter.HtmlContent ?? '';
      if (content.isEmpty) continue;

      // Remove the unwanted first line if it starts with <title> and ends with </title>.
      if (content.startsWith('<title>') && content.contains('</title>')) {
        int firstParagraphEndIndex = content.indexOf('</title>') + 4;
        content = content.substring(firstParagraphEndIndex).trim();
      }

      final paragraphs = content.split('<p>');
      List<String> pages = [];
      String pageContent = '';
      for (var paragraph in paragraphs) {
        if ((pageContent.length + paragraph.length) > maxContentLength) {
          pages.add(pageContent);
          pageContent = paragraph;
        } else {
          pageContent += '<p>$paragraph';
        }
      }
      if (pageContent.isNotEmpty) {
        pages.add(pageContent);
      }
      chapterPages.add(pages);
    }
    return chapterPages;
  }

  // Build the chapter content with HTML rendering
  Widget _buildChapterContent(String content) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HtmlWidget(
          content,
          customWidgetBuilder: (element) {
            return SelectableText.rich(TextSpan(text: element.text));
          },
          // textStyle: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }

  // Load progress (last chapter and page)
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentChapter = prefs.getInt('chapter${widget.id}') ?? 0;
      debugPrint(prefs.getInt('chapter${widget.id}').toString());
      debugPrint("Progresssssssssssssssssss");
      _currentPage = prefs.getInt('page${widget.id}') ?? 0;
      _pageController = PageController(initialPage: _currentPage);
    });
  }

  // Save progress (current chapter and page)
  Future<void> _saveProgress() async {
    debugPrint("chapter${widget.id}");

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('chapter${widget.id}', _currentChapter);
    prefs.setInt('page${widget.id}', _currentPage);
  }

  @override
  void dispose() {
    super.dispose();
    _saveProgress(); // Save the progress when the app is closed or when the user leaves
  }

  Future<void> _loadHighlights() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedHighlights = prefs.getStringList('highlights${widget.id}');
    if (savedHighlights != null) {
      setState(() {
        _highlights = savedHighlights.map((highlight) {
          final parts = highlight.split(',');
          return Highlight(
            chapterIndex: int.parse(parts[0]),
            pageIndex: int.parse(parts[1]),
            startIndex: int.parse(parts[2]),
            endIndex: int.parse(parts[3]),
          );
        }).toList();
      });
    }
  }

  // Save highlights to shared preferences
  Future<void> _saveHighlights() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedHighlights = _highlights.map((highlight) {
      return '${highlight.chapterIndex},${highlight.pageIndex},${highlight.startIndex},${highlight.endIndex}';
    }).toList();
    prefs.setStringList('highlights${widget.id}', savedHighlights);
  }

  List<Highlight> _highlights = []; // Store highlights
  // Add highlight to the list
  void _addHighlight(int startIndex, int endIndex) {
    setState(() {
      _highlights.add(Highlight(
        chapterIndex: _currentChapter,
        pageIndex: _currentPage,
        startIndex: startIndex,
        endIndex: endIndex,
      ));
    });
    _saveHighlights(); // Save the highlight
  }

  // Check if a portion of text should be highlighted
  bool _isHighlighted(int startIndex, int endIndex) {
    for (var highlight in _highlights) {
      if (highlight.chapterIndex == _currentChapter &&
          highlight.pageIndex == _currentPage &&
          highlight.startIndex >= startIndex &&
          highlight.endIndex <= endIndex) {
        return true;
      }
    }
    return false;
  }

  // Open the chapter selection dialog
  void _openChapterSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ListView.builder(
          itemCount: _chapters?.length ?? 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                _chapters![index].Title ?? 'Chapter ${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentChapter = index;
                  _currentPage = 0; // Reset to the first page of the selected chapter
                  _pageController.jumpToPage(0);
                  _saveProgress();
                });
              },
            );
          },
        ),
      ),
    );
  }

  // Previous page
  void _previousPage() {
    if (_pageController.hasClients) {
      if (_pageController.page == 0 && _currentChapter > 0) {
        setState(() {
          _currentChapter--;
        });
        _pageController.jumpToPage(0);
      } else {
        _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
      _saveProgress();
    }
  }

  // Next page
  void _nextPage() {
    if (_pageController.hasClients) {
      if (_pageController.page == _chapterPages[_currentChapter].length - 1 &&
          _currentChapter < _chapterPages.length - 1) {
        setState(() {
          _currentChapter++;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _pageController.jumpToPage(0);
        });
      } else {
        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linearToEaseOut);
      }
      _saveProgress();
    }
  }

  // Next chapter
  void _nextChapter() {
    if (_currentChapter < _chapterPages.length - 1) {
      setState(() {
        _currentChapter++;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _epubBook?.Title ?? 'EPUB Viewer', // Show the book title in the app bar
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: () => _openChapterSelectionDialog(context),
          ),
        ],
      ),
      body: _epubBook != null && _chapters != null && _chapters!.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _chapterPages[_currentChapter].length,
                    itemBuilder: (context, index) {
                      return _buildChapterContent(_chapterPages[_currentChapter][index]);
                    },
                    onPageChanged: (index) {
                      if (index == -1 || index == 0) {
                        setState(() {
                          _nextChapter();
                        });
                      } else if (index == _chapterPages[_currentChapter].length) {
                        _nextChapter();
                      } else {
                        _saveProgress();
                      }

                      _currentPage = index;
                      // });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _chapters![_currentChapter].Title ?? 'Chapter ${_currentChapter + 1}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _previousPage,
                        child: const Text('Previous'),
                      ),
                      TextButton(
                        onPressed: () {
                          // _nextChapter();
                          _nextPage();
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
