// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
enum FileType { PDF, DOCX, EPUB }

class Author {
  String name;
  int? booksPublished;
  String? profileImageUrl;

  Author({required this.name, this.booksPublished, this.profileImageUrl});
}

class Book {
  String id;
  String title;
  String description;
  Author author;
  String link;
  FileType type;
  String coverImageLink;
  String? aboutBook;
  String? price;

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.link,
    required this.type,
    required this.coverImageLink,
    this.aboutBook,
    this.price,
  });
}
