// // Copyright ©2022, GM Consult (Pty) Ltd
// // BSD 3-Clause License
// // All rights reserved

// import 'dart:convert';
// import 'dart:io';
// import 'package:gmconsult_dev/type_definitions.dart';

// /// A test utility class to save your test results to a file.
// abstract class SaveAs {
//   //

//   /// Saves the [text] to [fileName].[extension].
//   ///
//   /// If a path is not included, saves the file to the root of the code
//   /// repository.
//   static Future<void> text(
//       {required String fileName,
//       required String text,
//       String extension = 'txt'}) async {
//     final file = File('$fileName.$extension').openWrite();
//     final textList = paragraphSplitter(text);
//     final buffer = StringBuffer();
//     for (final paragraph in textList) {
//       buffer.writeln(paragraph);
//     }
//     file.writeln(buffer.toString());
//     await file.close();
//   }

//   /// Saves the [json] to [fileName].[extension] after calling [jsonEncode]
//   /// on [json].
//   ///
//   /// If a path is not included, saves the file to the root of the code
//   /// repository.
//   static Future<void> json(
//       {required String fileName,
//       required JSON json,
//       String extension = 'json'}) async {
//     final file = File('$fileName.$extension').openWrite();
//     final text = jsonEncode(json).replaceAllMapped(
//         RegExp(r'(,|,\s+)(?=[",\]\}\n\r])|[\n\r]|\n\r|[{}]'), (match) {
//       final e = match[0];
//       if (e is String) {
//         return (e == '}') ? '\n   $e' : '$e\n   ';
//       }
//       return '';
//     });
//     file.writeln(text.toString());
//     await file.close();
//   }

//   /// Saves the [results] to [fileName].[extension] after calling [jsonEncode]
//   /// on each element in [results].
//   ///
//   /// The file contains a dart const Map<dynamic, Map<String, dynamic>> named
//   /// [varName].
//   ///
//   /// The [keyBuilder] is used to get the top level keys from [results].
//   ///
//   /// If a path is not included, saves the file to the root of the code
//   /// repository.
//   static Future<void> results(
//       {required String fileName,
//       required TestResults results,
//       required KeyBuilder keyBuilder,
//       String varName = 'results',
//       String extension = 'dart'}) async {
//     final buffer = StringBuffer();
//     buffer.writeln('const $varName = {');
//     for (final json in results) {
//       buffer.write('${_toDart(keyBuilder(json))}: ');
//       buffer.write(_toDart(json));
//       buffer.writeln(',');
//     }
//     buffer.writeln('};');
//     final file = File('$fileName.$extension').openWrite();
//     file.writeln(buffer.toString());
//     await file.close();
//   }

//   static String _toDart(dynamic value) => value == null
//       ? 'null'
//       : jsonEncode(value)
//           .replaceAll("'", r"\'")
//           .replaceAll(r'$', r'\$')
//           .replaceAll('"', "'");

//   /// Matches all line endings.
//   static const _reLineEndingSelector = '[\u000A\u000B\u000C\u000D]+';

//   /// Returns a list of paragraphs from text.
//   static List<String> paragraphSplitter(String source) {
//     final sentences = source.trim().split(RegExp(_reLineEndingSelector));
//     final retVal = <String>[];
//     for (final e in sentences) {
//       final sentence = e.trim();
//       if (sentence.isNotEmpty) {
//         retVal.add(sentence);
//       }
//     }
//     return retVal;
//   }
// }
