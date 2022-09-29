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

TODO: Overview

A collection of utilities used for unit testing and code generation.  May require knowledge of
GM Consult coding practices and management systems.

Use the `Echo` class to print a collection JSON documents to the console as a formatted table.

## Usage

In the `pubspec.yaml` of your flutter project, add the following dev dependency:

```yaml
dev_dependencies:
  gmconsult_dev: <latest_version>
```

In your test file add the following import:

```dart
import 'package:gmconsult_dev/gmconsult_dev.dart';
```

Pass a collection of JSON documents to the `Echo()` factory constructor and call `printResults`:
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


## API

See the [API on pub.dev](https://pub.dev/documentation/gmconsult_dev/latest/).

## Definitions

None

## References

None

## Issues

GM Consult team members should [log issues and bugs](https://github.com/GM-Consult-Pty-Ltd/gmconsult_dev/issues).  

This project is an internal package for GM Consult projects and we cannot respond to pull requests or issues raised by non team members.


