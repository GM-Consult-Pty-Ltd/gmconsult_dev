// Copyright ©2022, GM Consult (Pty) Ltd
// BSD 3-Clause License
// All rights reserved

/// Alias for `Map<String, dynamic>`.
typedef JSON = Map<String, dynamic>;

/// Alias for `Map<String, Map<String, dynamic>>;`.
typedef JsonCollection = Map<String, Map<String, dynamic>>;

/// Alias for `List<Map<String, dynamic>>`.
typedef TestResults = Iterable<Map<String, dynamic>>;

/// Alias for `dynamic Function(Map<String, dynamic> json)`.
///
/// Use to find a primary key in [JSON].
typedef KeyBuilder = dynamic Function(Map<String, dynamic> json);
