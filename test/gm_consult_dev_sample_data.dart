// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

part 'data/sample_news.dart';
part 'data/sample_stocks.dart';

/// Sample data sets used for testing.
abstract class GMConsultDevSampleData {
  //

  /// A sample data set of sharemarket related JSON documents.
  ///
  /// Returns a Map<String, Map<String, dynamic>>
  static const stockNews = _sampleNews;

  /// A small collection of stock data JSON documents for
  /// - AAPL.XNGS,
  /// - GOOG:XNGS,
  /// - GOOGL:XNGS,
  /// - TSLA:XNGS,
  static const stockData = _sampleStocks;

  /// Simple list of JSON documents to test [Echo] class.
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
}
