// Copyright ©2022, GM Consult (Pty) Ltd
// BSD 3-Clause License
// All rights reserved

import 'package:gmconsult_dev/src/typedefs.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'dart:io';

/// A test utility class to save your test results to a file.
abstract class SaveAs {
  //

  /// Saves the [text] to [fileName] with [extension].
  ///
  /// If [path] is not provided, saves the file to the root of the code
  /// repository.
  static Future<void> text(
      {required String fileName,
      required String text,
      String path = '',
      String extension = 'txt'}) async {
    path = path
        .replaceAll(RegExp(r'[^a-zA-Z0-9_.\-\s\\/]'), '_')
        .replaceAll('/', r'\');
    fileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_.\-\s]'), '_');
    extension = extension.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final file = File(_fileRef(fileName, text, path, extension)).openWrite();
    final textList = paragraphSplitter(text);
    final buffer = StringBuffer();
    for (final paragraph in textList) {
      buffer.writeln(paragraph);
    }
    file.writeln(buffer.toString());
    await file.close();
  }

  static String _fileRef(
      String fileName, String text, String path, String extension) {
    path = path
        .replaceAll(RegExp(r'[^a-zA-Z0-9_.\-\s\\/]'), '_')
        .replaceAll('/', r'\');
    fileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_.\-\s]'), '_');
    extension = extension.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    return '$path\\$fileName.$extension'.replaceAll(r'\\', r'\');
  }

  /// Matches all line endings.
  static const _reLineEndingSelector = '[\u000A\u000B\u000C\u000D]+';

  /// Returns a list of paragraphs from text.
  static List<String> paragraphSplitter(String source) {
    final sentences = source.trim().split(RegExp(_reLineEndingSelector));
    final retVal = <String>[];
    for (final e in sentences) {
      final sentence = e.trim();
      if (sentence.isNotEmpty) {
        retVal.add(sentence);
      }
    }
    return retVal;
  }
}
