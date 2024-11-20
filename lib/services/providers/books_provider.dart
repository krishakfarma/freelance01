import 'package:ebook_reader/services/models/book_model.dart';
import 'package:flutter/material.dart';

class BooksProvider extends ChangeNotifier {
  BooksProvider() {
    addBooksToList();
  }
  Book book1 = Book(
    id: "1",
    title: "JUMBO",
    author: Author(name: "Abdul Kalam"),
    link: "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
    description: "",
    type: FileType.PDF,
    coverImageLink: "https://m.media-amazon.com/images/I/81SkrVxlH0L._AC_UF1000,1000_QL80_.jpg",
    price: "300.00",
  );

  Book book2 = Book(
    id: "2",
    title: "The 39 Steps",
    author: Author(name: "John Creasey"),
    link: "https://www.gutenberg.org/ebooks/11.epub.noimages",
    description: "",
    type: FileType.EPUB,
    coverImageLink: "https://m.media-amazon.com/images/I/81CKhiPTYuL.jpg",
    price: "450.00",
  );

  Book book3 = Book(
    id: "3",
    title: "JUMBO",
    author: Author(name: "Abdul Kalam"),
    link: "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
    description: "",
    type: FileType.PDF,
    price: "300.00",
    coverImageLink: "https://m.media-amazon.com/images/I/81SkrVxlH0L._AC_UF1000,1000_QL80_.jpg",
  );
  Book book4 = Book(
    id: "4",
    title: "The 39 Steps",
    author: Author(name: "John Creasey"),
    link: "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
    description: "",
    type: FileType.DOCX,
    price: "350.00",
    coverImageLink: "https://m.media-amazon.com/images/I/81CKhiPTYuL.jpg",
  );
  Book book5 = Book(
    id: "5",
    title: "JUMBO",
    author: Author(name: "Abdul Kalam"),
    link: "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
    description: "",
    type: FileType.PDF,
    price: "140.00",
    coverImageLink: "https://m.media-amazon.com/images/I/81SkrVxlH0L._AC_UF1000,1000_QL80_.jpg",
  );
  Book book6 = Book(
    id: "6",
    title: "The 39 Steps",
    author: Author(name: "John Creasey"),
    link: "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
    description: "",
    type: FileType.DOCX,
    price: "80.00",
    coverImageLink: "https://m.media-amazon.com/images/I/81CKhiPTYuL.jpg",
  );
  Book book7 = Book(
    id: "5",
    title: "JUMBO",
    author: Author(name: "Abdul Kalam"),
    link: "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
    description: "",
    type: FileType.PDF,
    coverImageLink: "https://m.media-amazon.com/images/I/81SkrVxlH0L._AC_UF1000,1000_QL80_.jpg",
  );

  late List<Book> suggestionBooks;
  late List<Book> latestBooks;

  void addBooksToList() {
    suggestionBooks = [book1, book2, book3, book4, book5, book6, book7];
    latestBooks = [book1, book2, book3, book4, book5, book6, book7];

    notifyListeners();
  }

  int activeIndex = 0;

  void updateIndex(int index) {
    activeIndex = index;
    notifyListeners();
  }

  bool isEpubLoaded = false;

  void epubLoading() {
    isEpubLoaded = false;
    print("EPUB Loadin......");
    notifyListeners();
  }

  void epubLoaded() {
    isEpubLoaded = true;
    print("EPUB Loaded");
    notifyListeners();
  }
}
