import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookProgressModel {
  int currentPageIndex;
  int currentChapterIndex;
  String bookId;

  BookProgressModel({
    required this.currentPageIndex,
    required this.currentChapterIndex,
    required this.bookId,
  });

  // Convert a BookProgressModel to a Map for JSON encoding
  Map<String, dynamic> toMap() {
    return {
      'currentPageIndex': currentPageIndex,
      'currentChapterIndex': currentChapterIndex,
      'bookId': bookId,
    };
  }

  // Create a BookProgressModel from a Map
  factory BookProgressModel.fromMap(Map<String, dynamic> map) {
    return BookProgressModel(
      currentPageIndex: map['currentPageIndex'] ?? 0,
      currentChapterIndex: map['currentChapterIndex'] ?? 0,
      bookId: map['bookId'] ?? '',
    );
  }

  // Encode to JSON string
  String toJson() => json.encode(toMap());

  // Decode from JSON string
  factory BookProgressModel.fromJson(String source) => BookProgressModel.fromMap(json.decode(source));
}

class BookProgressSingleton {
  final SharedPreferences prefs;

  BookProgressSingleton({required this.prefs});

  Future<bool> setCurrentChapterIndex(String bookId, int chapterIndex) async {
    try {
      String? jsonString = prefs.getString("epubBook${bookId}");
      BookProgressModel bookProgress;

      if (jsonString != null) {
        bookProgress = BookProgressModel.fromJson(jsonString);
        bookProgress.currentChapterIndex = chapterIndex;
      } else {
        bookProgress = BookProgressModel(
          currentPageIndex: 0,
          currentChapterIndex: chapterIndex,
          bookId: bookId,
        );
      }

      return await prefs.setString("epubBook${bookId}", bookProgress.toJson());
    } catch (e) {
      return false;
    }
  }

  Future<bool> setCurrentPageIndex(String bookId, int pageIndex) async {
    try {
      String? jsonString = prefs.getString("epubBook${bookId}");
      BookProgressModel bookProgress;

      if (jsonString != null) {
        bookProgress = BookProgressModel.fromJson(jsonString);
        bookProgress.currentPageIndex = pageIndex;
      } else {
        bookProgress = BookProgressModel(
          currentPageIndex: pageIndex,
          currentChapterIndex: 0,
          bookId: bookId,
        );
      }

      return await prefs.setString("epubBook${bookId}", bookProgress.toJson());
    } catch (e) {
      return false;
    }
  }

  BookProgressModel getBookProgress(String bookId) {
    String? jsonString = prefs.getString("epubBook${bookId}");
    if (jsonString != null) {
      return BookProgressModel.fromJson(jsonString);
    }
    return BookProgressModel(
      currentPageIndex: 0,
      currentChapterIndex: 0,
      bookId: bookId,
    );
  }

  Future<bool> deleteBookProgress(String bookId) async {
    try {
      return await prefs.remove(bookId);
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAllBooksProgress() async {
    try {
      final keys = prefs.getKeys();
      for (String key in keys) {
        await prefs.remove(key);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
