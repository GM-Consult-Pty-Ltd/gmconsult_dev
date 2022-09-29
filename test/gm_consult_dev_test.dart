// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

import 'package:gmconsult_dev/gmconsult_dev.dart';
import 'package:test/test.dart';
import 'data/data.dart';
import 'dart:math';

void main() {
  //
  final results = <Map<String, dynamic>>[];

  group('ECHO', () {
    setUp(() {
      var i = 0;
      for (final entry in json) {
        results.add({
          'Term': entry['other'],
          'Length Similarity': entry['cLs'],
          'Date': DateTime.now().subtract(Duration(days: i)),
          'Elapsed Time':
              Duration(milliseconds: (99 / (i + 1) * pow(50, i)).floor())
        });
        i++;
      }
    });

    test('.printResults(results)', (() {
      Echo(title: 'PRINT JSON: (Echo.printResults)', results: results)
          .printResults();
    }));

    //
  });

  //
}
