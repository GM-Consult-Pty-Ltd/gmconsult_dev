// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

part 'data/sample_news.dart';
part 'data/sample_stocks.dart';
part 'data/kgram_index.dart';
part 'data/countries.dart';
part 'data/currencies.dart';
part 'data/languages.dart';
part 'data/locales.dart';

/// Sample datasets used for testing.
abstract class TestData {
  //

  /// A sample dataset of k-grams from [stockNews].
  ///
  /// Returns Map<String, Set<String>>.
  static const kGramIndex = _kGramIndex;

  /// A sample dataset of sharemarket related JSON documents.
  ///
  /// Returns a `Map<String, Map<String, dynamic>>`.
  static const stockNews = _sampleNews;

  /// A small collection of stock data JSON documents for
  /// - AAPL:XNGS,
  /// - GOOG:XNGS,
  /// - GOOGL:XNGS, and
  /// - TSLA:XNGS.
  static const stockData = _sampleStocks;

  /// A long [String] with line breaks.
  static String get text => json['description'] as String;

  /// A single JSON document.
  static Map<String, dynamic> get json => stockData['GOOG:XNGS']!;

  /// Simple list of JSON documents.
  static const jsonList = [
    {'term': 'bodrer', 'other': 'bodrer', 'dL': 0.0, 'cLs': 1.0},
    {'term': 'bodrer', 'other': 'border', 'dL': 0.0, 'cLs': 1.0},
    {
      'term': 'bodrer',
      'other': 'boarder',
      'dL': 0.222395656,
      'cLs': 0.77761454
    },
    {'term': 'bodrer', 'other': 'brother', 'dL': 0.22253904, 'cLs': 0.7776176},
    {'term': 'bodrer', 'other': 'board', 'dL': 0.26303837, 'cLs': 0.736},
    {'term': 'bodrer', 'other': 'broad', 'dL': 0.263035476, 'cLs': 0.73697546},
    {'term': 'bodrer', 'other': 'bored', 'dL': 0.2630354, 'cLs': 0.7369766},
  ];

  /// A comprehensive list of countries in `JsonCollection
  /// (Map<String, Map<String, Object>>)` format.
  static const countries = _countries;

  /// A comprehensive list of currencies in `JsonCollection
  /// (Map<String, Map<String, Object>>)` format.
  static const currencies = _currencies;

  /// A comprehensive list of currencies in `JsonCollection
  /// (Map<String, Map<String, Object>>)` format.
  static const languages = _languages;

  /// A comprehensive list of currencies in `JsonCollection
  /// (Map<String, Map<String, Object>>)` format.
  static const locales = _locales;
}
