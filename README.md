# Fox Logging

[![codecov](https://codecov.io/gh/wim07101993/fox_logging/branch/master/graph/badge.svg?token=V3HOI9M93L)](https://codecov.io/gh/wim07101993/fox_logging)
[![Ensure code quality](https://github.com/wim07101993/fox_logging/actions/workflows/ensure_code_quality.yml/badge.svg?branch=master)](https://github.com/wim07101993/fox_logging/actions/workflows/ensure_code_quality.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)


A package containing some helpful extensions for the standard logging package.
It provides a flow to make logging more structured by introducing sinks and 
formatters. 

## Sink

A sink write a log entry to some place, like the console, file, database,...

```dart
final sink = IoLogSink(myFormatter);
```

## Formatter

Formatters format a `LogRecord` to a `String` in a certain way. This can be a 
pretty, verbose or simple, concise log. Or a complete custom implementation.

```dart
final simpleFormatter = SimpleFormatter();
```

## Small example

```dart
final logger = Logger('Simple');
final sink = IoLogSink(SimpleFormatter())
  ..listenTo(logger.onRecord);
```

Images below show the `SimpleFormatter` and `PrettyFormatter` when using the `PrintSink`.
`SimpleFormatter`:
![simple formaater output](https://user-images.githubusercontent.com/23017340/219139634-d3798e6b-564f-483f-b17e-9db88cd1c863.png)
`PrettyFormatter`:
![pretty formatter output](https://user-images.githubusercontent.com/23017340/219140524-345a8b26-e1e1-4b72-a48b-0672312cef2a.png)

For a more detailed example check out the [example](https://github.com/wim07101993/fox_logging/tree/master/example).
