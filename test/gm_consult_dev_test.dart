// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

@Timeout(Duration(minutes: 10))

import 'dart:convert';
import 'package:gmconsult_dev/gmconsult_dev.dart';
import 'package:gmconsult_dev/type_definitions.dart';
import 'package:gmconsult_dev/test_data.dart';
import 'package:test/test.dart';
import 'dart:io';

import 'keys.dart';

void main() {
  //

  group('API', (() {
    //

    test('.get', (() async {
      final path = 'api/v2/entries/en-us/api';
      final queryParameters = {'strictMatch': 'false'};
      final headers = Keys.oxfordDictionaries;
      final host = 'od-api.oxforddictionaries.com';
      final json = await API.get(
          host: host,
          path: path,
          queryParameters: queryParameters,
          headers: headers,
          isHttps: true);
      var definition = '';
      final results = json['results'];
      if (results is Iterable) {
        definition = ((((results.first['lexicalEntries']).first['entries'])
                    .first['senses'])
                .first['definitions'])
            .first
            .toString();
      }
      print('Endpoint:           ${json['_%path']}/${json['_%path']}');
      print('Query parameters:   ${json['_%query']}');
      print('Headers:            ${json['_%headers']}');
      print('Response code:      ${json['_%status']}');
      print('Metadata:           ${json['metadata']}');
      print('Definition:         $definition');
    }));

    //
  }));

  group('SaveAs', (() {
    //

    test('.text', (() async {
      await SaveAs.text(
        fileName: 'test/data/google',
        text: TestData.text,
      );
    }));

    test('.json', (() async {
      await SaveAs.json(
        fileName: 'test/data/google',
        json: TestData.json,
      );
    }));

    test('.results', (() async {
      await SaveAs.results(
        fileName: 'test/data/results',
        results: TestData.stockData.values,
        keyBuilder: (json) => json['id'],
      );
    }));

    //
  }));

  group('Console.out', () {
    test('.printResults(results)', (() {
      Console.out(
          title: 'PRINT JSON: (Console.printResults)',
          maxColWidth: 160,
          minPrintWidth: 200,
          results: TestData.stockData.values.toList(),
          fields: ['ticker', 'name', 'description']);
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
      Console.out(
          title: 'STOCKS',
          results: results,
          fields: ['hashTag', 'name', 'description']);

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

      Console.out(
          title: 'HASHTAGS',
          results: results,
          fields: ['hashTag', 'name', 'timestamp']);

      await service.close();
    }));

    test('JsonDataService.securities', (() async {
//   //

      final results = <Map<String, dynamic>>[];

      final service = await JsonDataService.securities;

      results.addAll((await service
              .batchRead(['AAPL:XNGS', 'TSLA:XNGS', 'INTC:XNGS', 'F:XNYS']))
          .values);

      Console.out(
          title: 'SECURITIES',
          results: results,
          fields: ['ticker', 'hashTag', 'name', 'timestamp']);

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

      Console.out(title: 'COUNTRIES', results: results);

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
