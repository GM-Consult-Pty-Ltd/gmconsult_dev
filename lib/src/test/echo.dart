// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

// ignore_for_file: unused_local_variable

import 'dart:math';
import 'package:collection/collection.dart';

/// Alias for `List<Map<String, dynamic>>`.
typedef TestResults = List<Map<String, dynamic>>;

/// Test utility class to echo your test results to the console.
///
/// Print list of JSON documents [results] to the console as a formatted table
/// with [title] as title and [fields] as column headings.
///
/// The column widths are calculated on the fly from the maximum width of any
/// value. The first column is left-justified. Subsequent columns are right
/// justified if the value is [num], and centered if any other type.
///
/// All values in [results] will be printed by calling [toString] on the value,
/// except for [double] values which will be formatted using `toStringAsFixed`
/// after calculating three popints of precision for all values in the field.
///
/// For any other formatting of values pre-format the value as [String] before
/// adding to [results].
///
/// that prints a list of JSON documents to the console as a
/// formatted table. Call the [printResults] method to print [results] to the
/// console:
/// - [results] is a collection of JSON documents with the same [fields];
/// - [fields] is an ordered collection field names in [results]. The output
///   table columns are ordered in the same order as [fields].
class Echo {
  //

  /// The name or title of the test for which results are printed.
  final String title;

  /// The white-space padding to add to the columns
  final int fieldPadding;

  /// Factory that initializes [Echo] with:
  /// - [title] will be printed at the top of your test results;
  /// - [results];
  /// - [fieldPadding] is the padding added to the columns, defaults to 5;
  /// - [fields] is an ordered collection field names in [results]. The output
  ///   table columns are ordered in the same order as [fields]. If [fields] is
  ///   null or empty the field names from the first element in [results] will
  ///   be used.
  factory Echo(
      {required String title,
      required TestResults results,
      int fieldPadding = 2,
      List<String>? fields}) {
    fields = fields ?? [];
    if (fields.isEmpty && results.isNotEmpty) {
      fields.addAll(results.first.keys);
    }
    final fieldWidths = <String, int>{};
    final fieldDigits = <String, int?>{};
    for (var i = 0; i < fields.length; i++) {
      final fieldName = fields[i];
      fieldWidths[fieldName] = results.fieldWidth(fieldName, fieldPadding);
      fieldDigits[fieldName] = results.fieldDigits(fieldName);
    }
    final fieldsWidth = fieldWidths.values.sum;
    var d = 0;
    if (fieldsWidth < 79) {
      d = ((79 - fieldsWidth) / fields.length).floor();
    } else if (title.length > fieldsWidth) {
      d = ((title.length - fieldsWidth) / fields.length).floor();
    }
    if (d > 0) {
      for (final entry in fieldWidths.entries) {
        fieldWidths[entry.key] = entry.value + d;
      }
    }

    return Echo._(
        title, results, fields, fieldWidths, fieldDigits, fieldPadding);
  }

  Echo._(this.title, this.results, this.fields, this._fieldWidths,
      this._fieldDigits, this.fieldPadding);

  /// An ordered collection field names in [results]. The output table columns
  /// are ordered in the same order as [fields].
  final List<String> fields;

  final Map<String, int> _fieldWidths;

  final Map<String, int?> _fieldDigits;

  /// A collection of JSON documents with the same [fields];
  final Iterable<Map<String, dynamic>> results;

  /// Print [results] to the console as a formatted table with [title] as
  /// title and [fields] as column headings.
  void printResults() {
    _printSeparator();
    _printTitle();
    _printSeparator('_');
    _printHeaders();
    _printSeparator();
    _printResults();
    _printSeparator();
  }

  static const _kRowSeparator = '—';

  static const _kColumnSeparator = '│';

  void _printSeparator([String separator = _kRowSeparator]) =>
      print(''.padRight(_printWidth, separator));

  int get _printWidth {
    final fieldsWidth = _fieldWidths.values.sum + _fieldWidths.length + 1;
    return fieldsWidth > title.length ? fieldsWidth : title.length;
  }

  void _printTitle() {
    print(title.padRight(_printWidth));
  }

  void _printResults() {
    for (final result in results) {
      _printResult(result);
    }
  }

  void _printResult(Map<String, dynamic> result) {
    final value = StringBuffer();
    value.write(_kColumnSeparator);
    for (var i = 0; i < fields.length; i++) {
      value.write(_value(fields[i], result));
      value.write(_kColumnSeparator);
    }
    print(value.toString());
  }

  void _printHeaders() {
    var i = 0;
    final headers = StringBuffer();
    headers.write(_kColumnSeparator);
    for (final fieldName in fields) {
      headers.write(_header(fieldName, i));
      headers.write(_kColumnSeparator);
      i++;
    }
    print(headers.toString());
  }

  String _header(String fieldName, int columnIndex) {
    final width = _fieldWidths[fieldName] as int;
    return columnIndex == 0
        ? fieldName.leftJustify(width, fieldPadding)
        : fieldName.center(width);
  }

  String _value(String fieldName, Map<String, dynamic> result) {
    final width = _fieldWidths[fieldName] as int;
    final value = result[fieldName];
    final columnIndex = fields.indexOf(fieldName);
    final text =
        value is Object ? value.toPrintString(_fieldDigits[fieldName]) : '';
    return columnIndex == 0
        ? text.leftJustify(width, fieldPadding)
        : value is num || value is Duration
            ? text.rightJustify(width, fieldPadding)
            : value is String
                ? text.leftJustify(width, fieldPadding)
                : text.center(width);
  }
}

extension _ObjectValueExtension on Object {
  String toPrintString([int? digits]) {
    final value = this;
    var text = '';
    if (value is double) {
      text = (digits == null ? value.toString() : value.toStringAsFixed(digits))
          .toString();
    } else if (value is DateTime) {
      text = '${value.year}/'
          '${value.month.toString().padLeft(2, '0')}/'
          '${value.day.toString().padLeft(2, '0')} '
          '${value.hour.toString().padLeft(2, '0')}:'
          '${value.minute.toString().padLeft(2, '0')}';
    } else if (value is Duration) {
      text = value.inDays >= 1
          ? '${(value.inHours / 24).toStringAsFixed(1)} days'
          : value.inHours >= 1
              ? '${(value.inMinutes / 60).toStringAsFixed(1)} hours'
              : value.inMinutes >= 1
                  ? '${(value.inSeconds / 60).toStringAsFixed(1)} minutes'
                  : value.inSeconds >= 1
                      ? '${(value.inMilliseconds / 1000).toStringAsFixed(1)} seconds'
                      : value.inMilliseconds >= 100
                          ? '${(value.inMilliseconds / 1000).toStringAsFixed(3)} seconds'
                          : '${value.inMilliseconds.toString()} ms';
    } else {
      text = value.toString();
    }
    return text;
  }
}

extension _IntValuesExtension on double {
  //

  int getFractionDigits() {
    int integer = 0;
    int exponent = 0;
    if (floor() != this) {
      do {
        integer = (this * pow(10, exponent)).floor();
        exponent++;
      } while (integer == 0);
    }
    final e = this * pow(10, exponent);
    return e.floor() == e
        ? exponent
        : e.floor() * 10 == e * 10
            ? exponent + 1
            : e.floor() * 100 == e * 100
                ? exponent + 2
                : exponent + 3;
  }
}

extension _JsonExtension on Iterable<Map<String, dynamic>> {
//

  /// Returns the width of the [fieldName] field
  int? fieldDigits(String fieldName) {
    final digits = <int>[];
    for (final result in this) {
      final value = result[fieldName];
      final d = value is double ? value.getFractionDigits() : null;
      if (d != null) digits.add(d);
    }
    if (digits.isEmpty) return null;
    digits.sort((a, b) => b.compareTo(a));
    return digits.first;
  }

  /// Returns the width of the [fieldName] field
  int fieldWidth(String fieldName, int padding) {
    final widths = [fieldName.length];
    for (final result in this) {
      final value = result[fieldName];
      final text = value is double
          ? value.toString()
          : value is Object
              ? value.toPrintString()
              : '';
      widths.add(text.length);
    }
    widths.sort((a, b) => b.compareTo(a));
    return widths.first + 2 * padding;
  }
}

extension _StringEchoExtension on String {
  //

  /// Pads the string with whitespace to the right to [width].
  String leftJustify(int width, [int margin = 0]) =>
      '${''.padLeft(margin)}$this'.padRight(width);

  /// Pads the string with whitespace to the right to [width].
  String rightJustify(int width, [int margin = 0]) =>
      '${this}${''.padRight(margin)}'.padLeft(width);

  /// Pads the string with equal amounts of whitespace to the left and right
  /// until the length of the string is [width].
  String center(int width) {
    final half = (length / 2).floor();
    final left = substring(0, half).padLeft((width / 2).floor());
    final right = substring(half, length).padRight(width - (width / 2).floor());
    return '$left$right';
  }
}
