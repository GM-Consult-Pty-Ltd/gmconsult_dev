// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

@Timeout(Duration(minutes: 10))

import 'dart:convert';

import 'package:gmconsult_dev/gmconsult_dev.dart';
import 'package:gmconsult_dev/type_definitions.dart';
import 'package:gmconsult_dev/test_data.dart';
import 'package:test/test.dart';

import 'dart:math';
import 'dart:io';

void main() {
  //

  // group('SaveAs', (() {
  //   //

  //   test('.text', (() async {
  //     await SaveAs.text(
  //       fileName: 'test/data/google',
  //       text: TestData.text,
  //     );
  //   }));

  //   test('.json', (() async {
  //     await SaveAs.json(
  //       fileName: 'test/data/google',
  //       json: TestData.json,
  //     );
  //   }));

  //   test('.results', (() async {
  //     await SaveAs.results(
  //       fileName: 'test/data/results',
  //       results: TestData.stockData.values,
  //       keyBuilder: (json) => json['id'],
  //     );
  //   }));

  //   //
  // }));

  group('ECHO', () {
    final results = <Map<String, dynamic>>[];
    setUp(() {
      var i = 0;
      for (final entry in TestData.jsonList) {
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
      Echo(
          title: 'PRINT JSON: (Echo.printResults)',
          maxColWidth: 160,
          minPrintWidth: 200,
          results: TestData.stockData.values.toList(),
          fields: ['ticker', 'name', 'description']).printResults();
    }));

    //
  });

  group('JsonDataService', (() {
    test('HiveJsonService.batchUpsert(sampleStocks)', (() async {
//   //

      final service = await JsonDataService.hydrate(
          '${Directory.current.path}\\test\\data', 'sampleStocks');

      // clear the datastore
      await service.dataStore.clear();

      // add all the elements of sampleStocks
      await service.batchUpsert(TestData.stockData);

      // read a few records
      final results =
          (await service.batchRead(['AAPL:XNGS', 'TSLA:XNGS'])).values.toList();

      // print the records
      Echo(
          title: 'STOCKS',
          results: results,
          fields: ['hashTag', 'name', 'description']).printResults();

      // close the service, releasing the resources
      await service.close();
    }));

    test('HiveJsonService.batchRead(hashtags)', (() async {
//   //

      final results = <Map<String, dynamic>>[];

      final service = await JsonDataService.hydrate(
          '${Directory.current.path}\\assets\\data', 'hashtags');

      results.addAll(
          (await service.batchRead(['Alphabet', 'Tesla', 'Intel', 'NVIDIA']))
              .values);

      Echo(
          title: 'HASHTAGS',
          results: results,
          fields: ['hashTag', 'name', 'timestamp']).printResults();

      await service.close();
    }));

    test('JsonDataService.securities', (() async {
//   //

      final results = <Map<String, dynamic>>[];

      final service = await JsonDataService.securities;

      results.addAll((await service
              .batchRead(['AAPL:XNGS', 'TSLA:XNGS', 'INTC:XNGS', 'F:XNYS']))
          .values);

      Echo(
          title: 'SECURITIES',
          results: results,
          fields: ['ticker', 'hashTag', 'name', 'timestamp']).printResults();

      await service.close();
    }));

    test('HiveJsonService.batchRead(countries)', (() async {
//   //

      final results = <Map<String, dynamic>>[];

      final service = await JsonDataService.hydrate(
          '${Directory.current.path}\\assets\\data', 'countries');

      final batch = await service.batchRead(['US', 'AU', 'ZA', 'GB']);
      for (final entry in batch.entries) {
        final country = entry.value;
        results.add({
          'ISO': country['id'],
          'Name': country['name'],
          'Capital': country['capital']['name'],
          'Currency': country['currency']
        });
      }

      Echo(title: 'COUNTRIES', results: results).printResults();

      await service.close();
    }));
  }));

  //
}

Future<void> saveKgramIndex(TestResults value) async {
  final out = File('kGramIndex.txt').openWrite();
  out.writeln('const vocabularykGrams = {');
  for (final e in value) {
    final buffer = StringBuffer();
    buffer.write('${_toDart(e['id'])}: {');
    buffer.write(_toDart(e));
    // var i = 0;
    // for (final entry in e.entries) {
    //   buffer.write(i > 0 ? ', ' : '');
    //   buffer.write('r"${entry.key}":');
    //   i++;
    // }
    buffer.write('},');
    out.writeln(buffer.toString());
  }
  out.writeln('};');
  await out.close();
}

// Future<void> results(
//     {required String fileName,
//     required TestResults results,
//     required KeyBuilder keyBuilder,
//     String varName = 'results',
//     String extension = 'dart'}) async {
//   final file = File('$fileName.$extension').openWrite();
//   file.writeln('const $varName = {');
//   for (final json in results) {
//     final buffer = StringBuffer();
//     buffer.write('${_toDart(keyBuilder(json))}: ');
//     buffer.writeln(_toDart(json));
//     buffer.write(',');
//     file.writeln(buffer.toString());
//   }
//   file.writeln('};');
//   await file.close();
// }

String _toDart(dynamic value) => value == null
    ? 'null'
    : jsonEncode(value)
        .replaceAll("'", r"\'")
        .replaceAll(r'$', r'\$')
        .replaceAll('"', "'");
