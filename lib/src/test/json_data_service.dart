// Copyright ©2022, GM Consult (Pty) Ltd
// BSD 3-Clause License
// All rights reserved

// ignore_for_file: deprecated_member_use_from_same_package

import 'package:gmconsult_dev/src/typedefs.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'dart:io';

/// Interface for a data service class that allows CRUD access to a [JSON]
/// repository.
///
/// Use for mocking asynchronous read/write operations to a persisted datastore.
///
/// [T] is the type of the dataStore field.
abstract class JsonDataService<T extends Object> {
  //

  /// Hydrates a [JsonDataService] with a large dataset of securities.
  static Future<JsonDataService<Box<String>>> get securities async {
    Hive.init('${Directory.current.path}\\assets\\data');
    final Box<String> dataStore = await Hive.openBox('securities');
    return HiveJsonService(dataStore);
  }

  /// Hydrates a [HiveJsonService] from a Box<String> with [name] at [path].
  ///
  /// If no box [name] exists at [path], a box will be created.
  static Future<JsonDataService<Box<String>>> hydrate(
      String path, String name) async {
    Hive.init(path);
    final Box<String> dataStore = await Hive.openBox(name);
    return HiveJsonService(dataStore);
  }

  /// Returns a [HiveJsonService] using the [dataStore].
  static JsonDataService<Box<String>> hive(Box<String> dataStore) =>
      HiveJsonService(dataStore);

  /// The datastore for the service.
  T get dataStore;

  /// Returns a [JsonCollection] for the [keys] from the [dataStore].
  Future<JsonCollection> batchRead(Iterable<String> keys);

  /// Writes the [values] to the [dataStore], overwriting any existing values.
  Future<void> batchUpsert(JsonCollection values);

  /// Creates a new [value] in the [dataStore] with [key]. If the [key] already
  /// exists an exception is raised.
  Future<void> create(String key, Map<String, dynamic> value);

  /// Returns true if an item with the [key] was deleted.
  Future<bool> delete(String key);

  /// Performs a field-wise update of an existing item in the [dataStore].
  ///
  /// Returns false if the document was not found in the [dataStore].
  Future<bool> update(String key, Map<String, dynamic> value);

  /// Returns a [JSON] document from the datastore if the [key] exists.
  Future<JSON?> read(String key);

  /// Closes the [dataStore] and disposes of the [JsonDataService].
  Future<void> close();
}

/// The [HiveJsonService] is an implementation of the [JsonDataService] interface
/// using [Box] as datastore. Mixes in [HiveJsonServiceMixin].
class HiveJsonService
    with HiveJsonServiceMixin
    implements JsonDataService<Box<String>> {
  //

  /// Hydrates a [HiveJsonService] from a Box<String> with [name] at [path].
  ///
  /// If no box [name] exists at [path], a box will be created.
  static Future<HiveJsonService> hydrate(String path, String name) async {
    Hive.init(path);
    final Box<String> dataStore = await Hive.openBox(name);
    return HiveJsonService(dataStore);
  }

  /// Instantiates a [HiveJsonService] instance with the [dataStore].
  HiveJsonService(this.dataStore);

  @override
  final Box<String> dataStore;
}

/// A mixin class that implements [JsonDataService] using [Box] as datastore.
abstract class HiveJsonServiceMixin implements JsonDataService<Box<String>> {
  //

  /// The Hive [JsonCollection] repository for the service.
  @override
  Box<String> get dataStore;

  @override
  Future<void> create(String key, Map<String, dynamic> value) async {
    final existing = dataStore.get(key);
    if (existing != null) {
      throw Exception(
          'An item with the key "$key" already exists in the datastore.');
    }
    await dataStore.put(key, jsonEncode(value));
  }

  @override
  Future<bool> update(String key, Map<String, dynamic> value) async {
    final existing = await read(key);
    if (existing == null) return false;
    for (final entry in value.entries) {
      existing[entry.key] = entry.value;
    }
    await dataStore.put(key, jsonEncode(existing));
    return true;
  }

  @override
  Future<bool> delete(String key) async {
    final value = dataStore.get(key);
    await dataStore.delete(key);
    return value != null;
  }

  @override
  Future<JSON?> read(String key) async {
    final value = dataStore.get(key);
    return value != null
        ? Map<String, dynamic>.from(
            (jsonDecode(value) as Map).map((k, v) => MapEntry(k as String, v)))
        : null;
  }

  @override
  Future<JsonCollection> batchRead(Iterable<String> keys) async {
    final JsonCollection retVal = {};
    for (final key in keys) {
      final entry = await read(key);
      if (entry != null) {
        retVal[key] = entry;
      }
    }
    return retVal;
  }

  @override
  Future<void> batchUpsert(JsonCollection values) async => dataStore
      .putAll(values.map((key, value) => MapEntry(key, jsonEncode(value))));

  @override
  Future<void> close() async {
    await dataStore.close();
    await Hive.close();
  }

  //
}
