# logging_extensions

A package containing some helpful extensions for the standard logging package.
It provides a flow to make logging more structured by introducing sinks and 
formatters. 

## Sink

A sink write a log entry to some place, like the console, file, database,...

```dart
final printSink = PrintSink(myFormatter);
```

## Formatter

Formatters format a `LogRecord` to a `String` in a certain way. This can be a 
pretty, verbose or simple, concise log. Or a complete custom implementation.

```dart
final simpleFormatter = SimpleFormatter();
```