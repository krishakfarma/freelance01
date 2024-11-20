// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:open_filex/open_filex.dart';

// class DocxViewerScreen extends StatefulWidget {
//   @override
//   _DocxViewerScreenState createState() => _DocxViewerScreenState();
// }

// class _DocxViewerScreenState extends State<DocxViewerScreen> {
//   // Updated URL with a different sample DOCX file
//   final String docUrl = 'https://github.com/jiaaro/pydub/blob/master/test/data/test.docx?raw=true';
//   File? _downloadedFile;

//   Future<void> downloadAndOpenDocx() async {
//     try {
//       // Get a temporary directory to save the downloaded file
//       final directory = await getTemporaryDirectory();
//       final filePath = '${directory.path}/sample.docx';

//       // Download the file
//       print('Starting download...');
//       final response = await http.get(Uri.parse(docUrl));

//       if (response.statusCode == 200) {
//         // Write the downloaded bytes to a file
//         _downloadedFile = File(filePath);
//         await _downloadedFile!.writeAsBytes(response.bodyBytes);
//         print('File downloaded to: $filePath');

//         // Open the file
//         final result = await OpenFilex.open(filePath);
//         print('File open result: ${result.message}');
//       } else {
//         print('Failed to download file: ${response.statusCode} ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       print('Error downloading or opening document: $e');
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     // Delete the file when the widget is disposed
//     _deleteDownloadedFile();
//   }

//   Future<void> _deleteDownloadedFile() async {
//     if (_downloadedFile != null && await _downloadedFile!.exists()) {
//       try {
//         await _downloadedFile!.delete();
//         print('Downloaded file deleted successfully.');
//       } catch (e) {
//         print('Error deleting the file: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('DOCX Viewer')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: downloadAndOpenDocx,
//           child: Text('Open DOC File'),
//         ),
//       ),
//     );
//   }
// }
