import 'package:ebook_reader/services/models/book_model.dart';
import 'package:flutter/material.dart';

class AuthorProvider extends ChangeNotifier {
  AuthorProvider() {
    _authors = [_author1, _author2, _author3, _author4];
  }

  final Author _author1 = Author(
    name: "J.K.Rowling",
    profileImageUrl: "https://lumos.contentfiles.net/media/thumbs/06/8a/068a60b41d286fbed0f447dd4e57a924.jpg",
  );

  final Author _author2 = Author(
    name: "John Green",
    profileImageUrl: "https://compote.slate.com/images/be7f1064-644e-41aa-a628-65e913ca88c0.jpg",
  );

  final Author _author3 = Author(
    name: "Elif Shafak",
    profileImageUrl: "https://literaturfestival.com/wp-content/uploads/Elif-Shafak_c-Ferhat-Elik-1.jpg",
  );

  final Author _author4 = Author(
    name: "Kazuo Ishiguro",
    profileImageUrl:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Kazuo_Ishiguro_in_2017_01.jpg/800px-Kazuo_Ishiguro_in_2017_01.jpg",
  );

  late List<Author> _authors;
  List<Author> get authors => _authors;
}
