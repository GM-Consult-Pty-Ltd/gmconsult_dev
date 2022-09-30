// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

@Timeout(Duration(minutes: 10))

import 'package:gmconsult_dev/gmconsult_dev.dart';
import 'package:test/test.dart';
import 'gm_consult_dev_sample_data.dart';
import 'dart:math';
import 'dart:io';

void main() {
  //

  group('ECHO', () {
    final results = <Map<String, dynamic>>[];
    setUp(() {
      var i = 0;
      for (final entry in GMConsultDevSampleData.jsonList) {
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
          results: GMConsultDevSampleData.stockData.values.toList(),
          fields: ['ticker', 'name', 'description']).printResults();
    }));

    //
  });

  group('JsonDataService', (() {
    test('HiveJsonService.batchUpsert(sampleStocks)', (() async {
//   //

      // final TestResults results = [];

      final service = await JsonDataService.hydrate(
          '${Directory.current.path}\\test\\data', 'sampleStocks');

      // clear the datastore
      await service.dataStore.clear();

      // add all the elements of sampleStocks
      await service.batchUpsert(GMConsultDevSampleData.stockData);

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
