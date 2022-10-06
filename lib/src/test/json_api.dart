// Copyright ©2022, GM Consult (Pty) Ltd
// BSD 3-Clause License
// All rights reserved

import '../typedefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Abstract class that exposes HTTP methods.
abstract class API {
  //

  /// Returns the [Uri] for the HTTP endpoint using the path, parameters
  /// and headers for the service API
  static Uri _uri(
      {required String host,
      String? path,
      Map<String, String>? queryParameters,
      bool isHttps = true}) {
    if (isHttps) {
      return Uri.https(host, path ?? '/', queryParameters);
    }
    return Uri.http(host, path ?? '/', queryParameters);
  }

  /// Returns a HTTP [http.Response] from the [uri], adding [headers] to the GET.
  static Future<http.Response?> _getUri(Uri uri,
      {Map<String, String>? headers,
      Duration timeout = const Duration(seconds: 5)}) async {
    int tries = 0;
    final delay =
        timeout.inSeconds < 1 ? timeout : const Duration(milliseconds: 1000);
    http.Response? response;
    do {
      try {
        headers = headers?.isEmpty ?? true ? null : headers;
        response = await http.get(uri, headers: headers).timeout(timeout);
        final statusCode = response.statusCode;
        if (statusCode != 200) {
          response = null;
          throw ('The response status code was $statusCode');
        }
      } on Exception {
        await Future.delayed(delay);
        tries++;
        response = null;
      }
    } while (tries < 5 && response == null);
    return response;
  }

  /// Returns a HTTP [http.Response] from the raw [url].
  // ignore: unused_element
  static Future<http.Response?> _getUrl(String url,
          {Duration timeout = const Duration(seconds: 35)}) =>
      _getUri(Uri.parse(url), headers: null, timeout: timeout);

  // ignore: unused_element
  Future<http.Response?> _get(
          {required String host,
          String? path,
          Map<String, String>? queryParameters,
          Map<String, String>? headers,
          bool isHttps = true,
          Duration timeout = const Duration(seconds: 35)}) =>
      _getUri(
          _uri(
              host: host,
              path: path,
              queryParameters: queryParameters,
              isHttps: isHttps),
          headers: headers,
          timeout: timeout);

  /// Fetches the JSON object from the HTTP endpoint using the [path],
  /// [queryParameters] and [headers] for the RESTful service [host].
  ///
  /// If the response body is not a `Map<String, dynamic>`, the body will
  /// be wrapped in a hashmap in a field with the key "data".
  ///
  /// The HTTP request/response properties are added to the JSON with the
  /// following keys:
  /// - the "_%path" is the endpoint path string;
  /// - the "_%status" is the response statusCode;
  /// - the "_%query" is a hashmap containing the request query parameters;
  /// - the "_%headers" is a hashmap containing the request headers;
  ///
  /// If an error occurs the "data" field will contain the error object.
  ///
  /// If no response is received, the "data" field contains a generic
  /// error message and the status code is `-1`.
  static Future<JSON> get(
      {required String host,
      String? path,
      Map<String, String>? queryParameters,
      Map<String, String>? headers,
      bool isHttps = true,
      Duration timeout = const Duration(seconds: 5)}) async {
    final uri = _uri(
        host: host,
        path: path,
        queryParameters: queryParameters,
        isHttps: isHttps);
    var data = 'An unspecified error has occurred. No response was received '
        'from the server.';
    var statusCode = -1;
    try {
      final response = await _getUri(uri, headers: headers, timeout: timeout);
      data = response?.body ?? data;
      statusCode = response?.statusCode ?? statusCode;
    } catch (e) {
      data = e.toString();
    }
    return _decodeJson(data, uri, headers, statusCode);
  }

  /// Decodes the response body and adds request/response metadata.
  static JSON _decodeJson(String responseBody, Uri uri,
      Map<String, String>? headers, int statusCode) {
    JSON json = {};
    dynamic data;
    try {
      data = jsonDecode(responseBody);
    } on Exception catch (e) {
      print(e);
      if (e is FormatException) {
        final start = (e.offset ?? 10) - 10;
        final finish = (e.offset ?? 10) + 10;
        final snippet = responseBody.substring(start, finish);
        print(snippet);
      }
    }
    if (data is JSON) {
      json = data;
    } else if (data is String) {
      json['data'] = '"$data"';
    } else {
      json['data'] = data;
    }
    json['_%path'] = uri.path;
    json['_%host'] = uri.host;
    json['_%url'] = uri.toString();
    json['_%status'] = statusCode;
    json['_%query'] = uri.queryParameters;
    json['_%headers'] = headers ?? {};
    return json;
  }

  /// Posts JSON [body] to the HTTP endpoint using the[host],  [path],
  /// [queryParameters] and [headers] using HTTPS if [isHttps].
  ///
  /// If the response body is not a `Map<String, dynamic>`, the body will
  /// be wrapped in a hashmap in a field with the key "data".
  ///
  /// The HTTP request/response properties are added to the JSON with the
  /// following keys:
  /// - the "_%path" is the endpoint path string;
  /// - the "_%status" is the response statusCode;
  /// - the "_%query" is a hashmap containing the request query parameters;
  /// - the "_%headers" is a hashmap containing the request headers;
  ///
  /// If an error occurs the "data" field will contain the error object.
  ///
  /// If no response is received, the "data" field contains a generic
  /// error message and the status code is `-1`.
  static Future<JSON?> post(
      {required String host,
      String? path,
      Map<String, String>? queryParameters,
      Map<String, String>? headers,
      JSON? body,
      bool isHttps = true}) async {
    final uri = _uri(
        host: host,
        path: path,
        queryParameters: queryParameters,
        isHttps: isHttps);
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, convert to JSON and
      // return the result.
      return _decodeJson(response.body, uri, headers, response.statusCode);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('The server failed to respond in a timely manner');
    }
  }
}
