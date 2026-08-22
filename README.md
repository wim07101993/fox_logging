# Fox Logging

[![codecov](https://codecov.io/gh/wim07101993/fox_logging/branch/master/graph/badge.svg?token=V3HOI9M93L)](https://codecov.io/gh/wim07101993/fox_logging)
[![Ensure code quality](https://github.com/wim07101993/fox_logging/actions/workflows/ensure_code_quality.yml/badge.svg?branch=master)](https://github.com/wim07101993/fox_logging/actions/workflows/ensure_code_quality.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)


A package containing some helpful extensions for the standard logging package.
It provides a flow to make logging more structured by introducing sinks and 
formatters. 

## Sink

A sink writes a log entry to some place, like the console, file, database,...

```dart
final sink = IoLogSink(myFormatter);
```

The built-in sinks are:

| Sink             | Writes to                                            |
|------------------|------------------------------------------------------|
| `IoLogSink`      | `stdout`, and `stderr` for `Level.SEVERE` and higher |
| `PrintSink`      | the `print` function, line per line                  |
| `DevLogSink`     | the `dart:developer` `log` function                  |
| `StreamLogSink`  | a `Stream<LogRecord>` you can listen to              |
| `MultiLogSink`   | a list of other sinks                                |

Hand a record to a sink with `log`: it applies the [filter](#filter) and keeps
a failing sink from throwing into the program it logs for. `write` is the raw
counterpart which every sink implements.

```dart
await sink.log(record); // filtered
await sink.write(record); // unfiltered

// override onError to find out about failing writes
class MySink with LogSinkMixin {
  @override
  void onError(Object error, StackTrace stackTrace) => ...;
}
```

Call `dispose` when you are done with a sink. It cancels the subscriptions
made by `listenTo`, and releases whatever else the sink holds (the stream of a
`StreamLogSink`, the sinks of a `MultiLogSink`,...).

## Formatter

Formatters format a `LogRecord` to a `String` in a certain way. This can be a 
pretty, verbose or simple, concise log. Or a complete custom implementation.

```dart
final simpleFormatter = SimpleFormatter();
```

The built-in formatters are `SimpleFormatter`, `PrettyFormatter`,
`JsonFormatter` and `LevelDependentFormatter`, which picks a formatter based on
the level of the record:

```dart
final formatter = LevelDependentFormatter(
  defaultFormatter: SimpleFormatter(),
  severe: PrettyFormatter(),
  shout: PrettyFormatter(),
);
```

## Filter

A filter decides which records reach a sink. Every sink takes one as its last
constructor argument and does not filter anything by default.

```dart
final errorsOnly = IoLogSink(SimpleFormatter(), const LogFilter.level(Level.SEVERE));
```

Each sink applies its own filter, also when it is wrapped in a `MultiLogSink`:

```dart
final sink = MultiLogSink([
  IoLogSink(PrettyFormatter()),
  // only errors end up in the json log
  IoLogSink(const JsonFormatter(), const LogFilter.level(Level.SEVERE)),
]);
```

Implement `LogFilter` for anything else.

## Parser

Parsers turn a `String` back into a `LogRecord`, which is useful to read back
logs written with the `JsonFormatter`.

```dart
final records = const JsonLogRecordParser().parseList(await file.readAsString());
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
