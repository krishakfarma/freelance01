// import 'package:flutter/foundation.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:test_ebook/Model/book_progress_model.g.dart';

// const SCHEMES = [BookProgressModelSchema];

// class IsarService {
//   late final Isar isar;

//   IsarService._create(this.isar);

//   static Future<Isar> buildIsarService() async {
//     final dir;

//     if (kIsWeb) {
//       // Set web-specific directory
//       dir = "/assets/";
//     } else {
//       dir = await getApplicationDocumentsDirectory();
//     }

//     var isarInstance = Isar.getInstance('cosmos_epub');

//     if (isarInstance == null) {
//       final isar = await Isar.open(
//         [BookProgressModelSchema],
//         name: 'cosmos_epub',
//         directory: kIsWeb ? dir : dir.path,
//       );

//       IsarService._create(isar);
//       return isar;
//     } else {
//       return isarInstance;
//     }
//   }
// }
