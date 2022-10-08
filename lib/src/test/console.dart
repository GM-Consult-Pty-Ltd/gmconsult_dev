// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

// ignore_for_file: unused_local_variable

import 'dart:math';
import 'package:collection/collection.dart';
import 'package:gmconsult_dev/src/typedefs.dart';

/// Test utility class to echo your JSON test results to the console:
/// - call the [Console.out] static method to print [results] to the console
///   as a formatted table with a [title] as title and the field names of the
///   JSON results as column headings; or
/// - call [Console.seperator] to print a horizontal line to the console.
class Console {
  //

  Console._(
      this.title,
      this.results,
      this.fields,
      this._fieldWidths,
      this._fieldDigits,
      this.fieldPadding,
      this.maxColWidth,
      this.minPrintWidth);

  /// Horizontal table row border character.
  static const kRowSeparator = '\u2500';

  /// Vertical table row border character.
  static const kColumnSeparator = '\u2502';

  /// The name or title of the test for which results are printed.
  final String title;

  /// The white-space padding to add to the columns
  final int fieldPadding;

  /// The maximum width of any column in the table.
  final int maxColWidth;

  /// The minimum print width of the table.
  ///
  /// If the sum of the column widths is less than [minPrintWidth], all
  /// columns will be made wider until the print width is equal to
  /// [minPrintWidth].
  final int? minPrintWidth;

  /// An ordered collection field names in [results]. The output table columns
  /// are ordered in the same order as [fields].
  final List<String> fields;

  final Map<String, int> _fieldWidths;

  final Map<String, int?> _fieldDigits;

  /// A collection of JSON documents with the same [fields];
  final Iterable<Map<String, dynamic>> results;

  /// Factory that initializes [Console] with:
  /// - [title] will be printed at the top of your test results;
  /// - [results];
  /// - [fieldPadding] is the padding added to the columns, defaults to 5;
  /// - [fields] is an ordered collection field names in [results]. The output
  ///   table columns are ordered in the same order as [fields]. If [fields] is
  ///   null or empty the field names from the first element in [results] will
  ///   be used;
  /// - [maxColWidth] is the maximum width of any column in the table. If the
  ///   width of the value printed in the column is wider than [maxColWidth]
  ///   the text will be truncated to [maxColWidth]; and
  /// - [minPrintWidth] is the minimum print width of the table.  If the sum of
  ///   the column widths is less than [minPrintWidth], all columns will be made
  ///   wider until the print width is equal to [minPrintWidth].
  /// The column widths are calculated on the fly from the maximum width of any
  /// value. The first column is left-justified. Subsequent columns are right
  /// justified if the value is [num], and centered if any other type.
  ///
  /// All values in [results] will be printed by calling [toString] on the value,
  /// except for [double] values which will be formatted using `toStringAsFixed`
  /// after calculating three points of precision for all values in the field.
  ///
  /// For any other formatting of values pre-format the value as [String] before
  /// adding to [results].
  static void out(
      {required String title,
      required TestResults results,
      int fieldPadding = 2,
      int maxColWidth = 40,
      int? minPrintWidth,
      List<String>? fields}) {
    fields = fields ?? [];
    if (fields.isEmpty && results.isNotEmpty) {
      fields.addAll(results.first.keys);
    }
    final fieldWidths = <String, int>{};
    final fieldDigits = <String, int?>{};
    for (final fieldName in fields) {
      fieldDigits[fieldName] = results.fieldDigits(fieldName);
    }
    for (final fieldName in fields) {
      fieldWidths[fieldName] = results.fieldWidth(
          fieldName, fieldPadding, maxColWidth, fieldDigits[fieldName]);
    }
    final fieldsWidth = fieldWidths.values.sum;
    var d = 0;
    if (minPrintWidth != null && fieldsWidth < minPrintWidth) {
      if (fieldsWidth < minPrintWidth) {
        d = ((minPrintWidth - fieldsWidth) / fields.length).floor();
      } else if (title.length > fieldsWidth) {
        d = ((title.length - fieldsWidth) / fields.length).floor();
      }
      if (d > 0) {
        for (final entry in fieldWidths.entries) {
          fieldWidths[entry.key] = entry.value + d;
        }
      }
    }

    final console = Console._(title, results, fields, fieldWidths, fieldDigits,
        fieldPadding, maxColWidth, minPrintWidth);
    console._print();
  }

  /// Print [results] to the console as a formatted table with [title] as
  /// title and [fields] as column headings.
  void _print() {
    _separator();
    _printTitle();
    _tableTopBorder();
    _printHeaders();
    _tableHeadersBorder();
    _printResults();
    _tableBottomBorder();
  }

  /// Print a separator of [width] using [char].
  static void seperator([int width = 80, String char = kRowSeparator]) {
    print(''.padRight(width, char));
  }

  /// Print a separator
  void _separator([String char = kRowSeparator]) =>
      seperator(_printWidth, char);

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

  void _printHeaders() {
    var i = 0;
    final headers = StringBuffer();
    headers.write(_kRightBorder);
    for (final fieldName in fields) {
      headers.write(_header(fieldName, i));
      headers.write(i < fields.length - 1 ? kColumnSeparator : _kRightBorder);
      i++;
    }
    print(headers.toString());
  }

  void _horizontalLine(
      String leftChar, String horzChar, String colBorder, String rightBorder) {
    final buffer = StringBuffer();
    var i = 0;
    buffer.write(leftChar);
    for (final fieldName in fields) {
      final width = _fieldWidths[fieldName] as int;
      buffer.write(''.padRight(width, horzChar));
      buffer.write(i < fields.length - 1 ? colBorder : rightBorder);
      i++;
    }
    print(buffer.toString());
  }

  static const _kRightBorder = '\u2551';

  static const _kDoubleLine = '\u2550';

  void _printResult(Map<String, dynamic> result) {
    final value = StringBuffer();
    value.write(_kRightBorder);
    for (var i = 0; i < fields.length; i++) {
      value.write(_value(fields[i], result));
      value.write(i < fields.length - 1 ? kColumnSeparator : _kRightBorder);
    }
    print(value.toString());
  }

  void _tableTopBorder() {
    _horizontalLine('\u2554', _kDoubleLine, '\u2564', '\u2557');
  }

  void _tableHeadersBorder() {
    _horizontalLine('\u255F', kRowSeparator, '\u253C', '\u2562');
  }

  void _tableBottomBorder() {
    _horizontalLine('\u255A', _kDoubleLine, '\u2567', '\u255D');
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
    final text = value is Object
        ? value.toPrintString(maxColWidth, _fieldDigits[fieldName])
        : '';
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
  //
  String toPrintString(int maxFieldWidth, int? digits) {
    maxFieldWidth = maxFieldWidth < 3 ? 3 : maxFieldWidth;
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
    return text.length > maxFieldWidth - 3
        ? '${text.substring(0, maxFieldWidth - 3)}...'
        : text;
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
  int fieldWidth(String fieldName, int padding, int maxColWidth, int? digits) {
    final widths = [fieldName.length];
    for (final result in this) {
      final value = result[fieldName];
      final text = value is double
          ? value.toString()
          : value is Object
              ? value.toPrintString(maxColWidth, digits)
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
