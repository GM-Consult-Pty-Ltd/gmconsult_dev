<!-- 
BSD 3-Clause License
Copyright (c) 2022, GM Consult Pty Ltd
All rights reserved. 
-->

# gmconsult_dev

[![GM Consult Pty Ltd](https://raw.githubusercontent.com/GM-Consult-Pty-Ltd/gmconsult_dev/main/assets/images/gmconsult_dev_header.png?raw=true "GM Consult Pty Ltd")](https://github.com/GM-Consult-Pty-Ltd)
## **Generate code and lubricate / standardize unit testing.**

*THIS PACKAGE IS **INTERNAL and UNLISTED**, AND SUBJECT TO BREAKING CHANGES WITHOUT NOTICE.*

Skip to section:
- [Overview](#overview)
- [Usage](#usage)
- [API](#api)
- [Definitions](#definitions)
- [References](#references)
- [Issues](#issues)

## Overview
A collection of utilities used for unit testing and code generation.  May require knowledge of
GM Consult coding practices and management systems:
* Use the [Echo](https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/Echo-class.html) class to print a collection JSON documents to the console as a formatted table.
* Use the [SaveAs]https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/SaveAs-class.html) class to save text and JSON documents to disk.
* Use datasets from the [TestData]https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/TestData-class.html) class in your unit tests.
* Use the [JsonDataService](https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/JsonDataService-class.html) class to quickly create and populate a asynchronous persisted datastore.

## Usage

Fully worked [examples](https://pub.dev/packages/gmconsult_dev/example) are included in the package.

In the `pubspec.yaml` of your flutter project, add the following dev dependency:

```yaml
dev_dependencies:
  gmconsult_dev: <latest_version>
```

In your test file add the following import:

```dart
// import the `Echo`, `SaveAs` and `JsonDataService` classes
import 'package:gmconsult_dev/gmconsult_dev.dart';

// import the typedefs
import 'package:gmconsult_dev/type_definitions.dart';

// import the `TestData` datasets
import 'package:gmconsult_dev/test_data.dart';
```

### Print to the console with [Echo](https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/Echo-class.html)

Pass a collection of JSON documents to the [Echo()](https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/Echo/Echo.html) unnamed factory constructor and call [printResults](https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/Echo/printResults.html):
```dart

// a sample list of JSON documents
final json =[
  {'Key':'item 1', 'Value': 1.3456},
  {'Key':'item 2', 'Value': 7.89}
];

// pass a title and results to a Echo instance and call printResults
Echo(title: 'MY TEST NAME', results: json).printResults();

// prints:
// —————————————————————————————————————————————————————————————————————————————————
// MY TEST NAME                                                                     
// _________________________________________________________________________________
// │  Key                                  │                 Value                 │
// —————————————————————————————————————————————————————————————————————————————————
// │  item 1                               │                               1.3456  │
// │  item 2                               │                               7.8900  │
// —————————————————————————————————————————————————————————————————————————————————

//
```

### Mock a data service with [JsonDataService](https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/JsonDataService-class.html)

Initialize a [JsonDataService](https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/JsonDataService-class.html), populate it and then read from it.

```dart

  // get some data
  final jsonCollection = {
    'term0': {'term': 'bodrer', 'dL': 0.0, 'cLs': 1.0},
    'term1': {'term': 'board', 'dL': 0.26303837, 'cLs': 0.736},
    'term2': {'term': 'border', 'dL': 0.0, 'cLs': 1.0},
    'term3': {'term': 'boarder', 'dL': 0.222395656, 'cLs': 0.77761454},
    'term4': {'term': 'brother', 'dL': 0.22239353904, 'cLs': 0.7776134576},
    'term5': {'term': 'broad', 'dL': 0.263035476, 'cLs': 0.73697546},
    'term6': {'term': 'bored', 'dL': 0.2630354, 'cLs': 0.7369766},
  };

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
  Echo(title: 'JSON DATA SERVICE', results: results).printResults();

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

```

### Save test results [SaveAs]https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/SaveAs-class.html) using [TestData]https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/TestData-class.html)

To save text, JSON or test results, just call the appropriate static method from the [SaveAs]https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/SaveAs-class.html) class. We are using datasets from the [TestData]https://pub.dev/documentation/gmconsult_dev/latest/gmconsult_dev/TestData-class.html) class in the examples below.

```dart

      // save text from a `TestData` dataset
      await SaveAs.text(
        fileName: 'test/data/google',
        text: TestData.text,
      );

      // save a JSON document from a `TestData` dataset
      await SaveAs.json(
        fileName: 'test/data/google',
        json: TestData.json,
      );

      // save your TestResults collection from a `TestData` dataset
      await SaveAs.results(
        fileName: 'test/data/results',
        results: TestData.stockData.values,
        keyBuilder: (json) => json['id'],
      );

```

## API

API documentation is available on [pub.dev](https://pub.dev/documentation/gmconsult_dev/latest/).

## Definitions

None

## References

None

## Issues

GM Consult team members should [log issues and bugs](https://github.com/GM-Consult-Pty-Ltd/gmconsult_dev/issues).  

This project is an internal package for GM Consult projects and we cannot respond to pull requests or issues raised by non team members.


