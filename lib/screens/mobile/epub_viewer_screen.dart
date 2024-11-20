// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:epubx/epubx.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:http/http.dart' as http;

// class EPUBViewer extends StatefulWidget {
//   const EPUBViewer({Key? key}) : super(key: key);

//   @override
//   _EPUBViewerState createState() => _EPUBViewerState();
// }

// class _EPUBViewerState extends State<EPUBViewer> {
//   EpubBook? _epubBook;
//   List<EpubChapter>? _chapters;
//   int _currentChapter = 0;
//   late PageController _pageController;
//   List<List<String>> _chapterPages = [];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: 0);
//     _loadEPUB();
//   }

//   Future<void> _loadEPUB() async {
//     try {
//       const url = 'https://www.gutenberg.org/ebooks/84.epub.noimages';

//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final Uint8List bytes = response.bodyBytes;
//         final epubBook = await EpubReader.readBook(bytes);
//         setState(() {
//           _epubBook = epubBook;
//           _chapters = epubBook.Chapters;
//           if (_chapters != null && _chapters!.isNotEmpty) {
//             _chapterPages = _splitChapterContentIntoPages();
//           }
//         });
//       }
//     } catch (e) {
//       print('Failed to load EPUB: $e');
//     }
//   }

//   List<List<String>> _splitChapterContentIntoPages() {
//     List<List<String>> chapterPages = [];
//     for (var chapter in _chapters!) {
//       final content = chapter.HtmlContent ?? '';
//       if (content.isEmpty) continue;

//       final paragraphs = content.split('<p>');
//       List<String> pages = [];
//       String pageContent = '';
//       for (var paragraph in paragraphs) {
//         if ((pageContent.length + paragraph.length) > 1500) {
//           pages.add(pageContent);
//           pageContent = paragraph;
//         } else {
//           pageContent += '<p>$paragraph';
//         }
//       }
//       if (pageContent.isNotEmpty) {
//         pages.add(pageContent);
//       }
//       chapterPages.add(pages);
//     }
//     return chapterPages;
//   }

//   Widget _buildChapterContent(String content) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: HtmlWidget(content, textStyle: TextStyle(fontSize: 16, color: Colors.black)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           _chapters != null && _chapters!.isNotEmpty
//               ? _chapters![_currentChapter].Title ?? 'EPUB Viewer'
//               : 'EPUB Viewer',
//           textAlign: TextAlign.center,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.menu_book),
//             onPressed: () => _openChapterSelectionDialog(context),
//           ),
//         ],
//       ),
//       body: _epubBook != null && _chapters != null && _chapters!.isNotEmpty
//           ? Column(
//               children: [
//                 Expanded(
//                   child: PageView.builder(
//                     controller: _pageController,
//                     itemCount: _chapterPages[_currentChapter].length,
//                     itemBuilder: (context, index) {
//                       return _buildChapterContent(_chapterPages[_currentChapter][index]);
//                     },
//                     onPageChanged: (index) {
//                       if (index == _chapterPages[_currentChapter].length - 1) {
//                         _nextChapter();
//                       }
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextButton(
//                         onPressed: _previousPage,
//                         child: Text('Previous'),
//                       ),
//                       Text('Chapter ${_currentChapter + 1}'),
//                       TextButton(
//                         onPressed: _nextPage,
//                         child: Text('Next'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }

//   void _openChapterSelectionDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: ListView.builder(
//           itemCount: _chapters?.length ?? 0,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(_chapters![index].Title ?? 'Chapter ${index + 1}'),
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   _currentChapter = index;
//                   _pageController.jumpToPage(0);
//                 });
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _previousPage() {
//     if (_pageController.hasClients) {
//       if (_pageController.page == 0 && _currentChapter > 0) {
//         setState(() {
//           _currentChapter--;
//         });
//         // Adding a delay to ensure that chapter transition is smooth
//         Future.delayed(const Duration(hours: 1000), () {
//           _pageController.jumpToPage(_chapterPages[_currentChapter].length - 1);
//         });
//       } else {
//         _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
//       }
//     }
//   }

//   void _nextPage() {
//     if (_pageController.hasClients) {
//       if (_pageController.page == _chapterPages[_currentChapter].length - 1 &&
//           _currentChapter < _chapterPages.length - 1) {
//         setState(() {
//           _currentChapter++;
//         });
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _pageController.jumpToPage(0);
//         });
//       } else {
//         _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
//       }
//     }
//   }

//   void _nextChapter() {
//     if (_currentChapter < _chapterPages.length - 1) {
//       setState(() {
//         _currentChapter++;
//       });
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _pageController.jumpToPage(0);
//       });
//     }
//   }
// }
