// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

// ignore_for_file: unused_import

import 'dart:io';

// import the `Console`, `SaveAs` and `JsonDataService` classes
import 'package:gmconsult_dev/gmconsult_dev.dart';

// import the typedefs if needed
import 'package:gmconsult_dev/type_definitions.dart';

// import the `TestData` datasets if needed
import 'package:gmconsult_dev/test_data.dart';

void main() async {
  //

  // get some JSON from an API
  await _getHttp();

  const jsonCollection = {
    'term0': {'term': 'bodrer', 'dL': 0.0, 'cLs': 1.0},
    'term1': {'term': 'board', 'dL': 0.26303837, 'cLs': 0.736},
    'term2': {'term': 'border', 'dL': 0.0, 'cLs': 1.0},
    'term3': {'term': 'boarder', 'dL': 0.222395656, 'cLs': 0.77761454},
    'term4': {'term': 'brother', 'dL': 0.22239353904, 'cLs': 0.7776134576},
    'term5': {'term': 'broad', 'dL': 0.263035476, 'cLs': 0.73697546},
    'term6': {'term': 'bored', 'dL': 0.2630354, 'cLs': 0.7369766},
  };

  // print the jsonCollection with the `Console.out` static method
  _printJson(jsonCollection);

  // save data to files using static methods of the `SaveAs` class
  await _saveAsExamples();

  // create a [JsonDataService] using a Hive Box and populate it with
  // jsonCollection
  await _jsonDataServiceExample(jsonCollection);
}

/// Save data to files using static methods of the `SaveAs` class.
Future<void> _saveAsExamples() async {
  // save text
  await SaveAs.text(
    fileName: 'example/data/google',
    text: TestData.text,
  );

  // save a JSON document
  await SaveAs.json(
    fileName: 'example/data/google',
    json: TestData.json,
  );

  // save your TestResults collection
  await SaveAs.results(
    fileName: 'example/data/results',
    results: TestData.stockData.values,
    keyBuilder: (json) => json['id'],
  );
}

/// Get some JSON from an [API].
Future<void> _getHttp() async {
//
  // Get some JSON data from a public API endpoint
  final json = await API.get(
      host: 'boredapi.com',
      path: 'api/activity',
      queryParameters: {'key': '5881028'},
      // headers: headers,
      isHttps: true);

  // print a seperator 70 charcters wide
  Console.seperator(70);
  // prints
  // ======================================================================

  // print the results
  print('Request URL:        ${json['_%url']}');
  print('Response code:      ${json['_%status']}');
  print('Activity:           ${json['activity']}');

// prints:
//
// MY TEST NAME
// ╔═══════════╤═════════════════╤════════════════╗
// ║  term     │       dL        │       cLs      ║
// ╟───────────┼─────────────────┼────────────────╢
// ║  bodrer   │        0.00000  │       1.00000  ║
// ║  board    │        0.26304  │       0.73600  ║
// ║  border   │        0.00000  │       1.00000  ║
// ║  boarder  │        0.22240  │       0.77761  ║
// ║  brother  │        0.22239  │       0.77761  ║
// ║  broad    │        0.26304  │       0.73698  ║
// ║  bored    │        0.26304  │       0.73698  ║
// ╚═══════════╧═════════════════╧════════════════╝

//
}

/// Example of printing JSON data with the [Console] class.
void _printJson(Map<String, Map<String, Object>> jsonCollection) {
  //

  /// print a horizontal double line.
  Console.seperator(80, '=');

  // pass a title and results to the Console.out static method to print results
  Console.out(title: 'MY TEST NAME', results: jsonCollection.values.toList());

  // prints:

// MY TEST NAME
// ╔═══════════╤═════════════════╤════════════════╗
// ║  term     │       dL        │       cLs      ║
// ╟───────────┼─────────────────┼────────────────╢
// ║  bodrer   │        0.00000  │       1.00000  ║
// ║  board    │        0.26304  │       0.73600  ║
// ║  border   │        0.00000  │       1.00000  ║
// ║  boarder  │        0.22240  │       0.77761  ║
// ║  brother  │        0.22239  │       0.77761  ║
// ║  broad    │        0.26304  │       0.73698  ║
// ║  bored    │        0.26304  │       0.73698  ║
// ╚═══════════╧═════════════════╧════════════════╝
}

/// Example of a [JsonDataService] using a Hive Box.
Future<void> _jsonDataServiceExample(
    Map<String, Map<String, Object>> jsonCollection) async {
  //

  // instantiate a JsonDataService
  final service = await JsonDataService.hydrate(
      '${Directory.current.path}\\example', 'sampleStocks');

  // clear the datastore
  await service.dataStore.clear();

  // add all the elements of sampleStocks
  await service.batchUpsert(jsonCollection);

  // read a few records
  final results = (await service.batchRead(['term3', 'term5'])).values.toList();

  // print the records
  Console.out(title: 'JSON DATA SERVICE', results: results);

  // close the service, releasing the resources
  await service.close();

  // prints:
  // ———————————————————————————————————————————————————————————————————————————————————
  // JSON DATA SERVICE
  // ___________________________________________________________________________________
  // │  term                  │             dL             │            cLs            │
  // ———————————————————————————————————————————————————————————————————————————————————
  // │  boarder               │                   0.22240  │                  0.77761  │
  // │  broad                 │                   0.26304  │                  0.73698  │
  // ———————————————————————————————————————————————————————————————————————————————————
}
