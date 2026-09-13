## 1.1.0

- feat: added `LogSinkMixin.log`, which applies the filter and catches errors
  thrown by `write`. Use it instead of `write` when handing a record to a sink.
- feat: added `LogSinkMixin.onError`, called when `write` fails or a log-stream
  emits an error. It does nothing by default, so a failing sink can no longer
  bring down the program it logs for.
- fix: `MultiLogSink` no longer bypasses the filters of the sinks it writes to.
- fix: `StreamLogSink.dispose` closes its stream, and completes even when
  nothing listened to the stream or the listener is paused. Previously it
  never completed, which also hung a `MultiLogSink` wrapping such a sink.
- fix: `MultiLogSink.dispose` disposes the sinks it writes to.
- fix: `LogSinkMixin.dispose` no longer cancels the same subscription twice.
- fix: `JsonLogRecordParser.parseLevel` returns `Level.FINE` for unknown level
  names and values instead of throwing a `StateError`.
- fix: `LogRecordFormatter.formatList` separates records with `\n` instead
  of `\r\n`.
- deprecated `LogSink`, use `LogSinkMixin` instead. The built-in sinks keep
  extending `LogSink` during the deprecation, so existing `LogSink` variables
  and collections keep compiling. The supertype is removed in 2.0.0.
- docs: documented filters, `MultiLogSink`, `DevLogSink`, `JsonFormatter` and
  the parsers in the readme.
- docs: the `onError` example in the readme compiles now.
- docs: documented the remaining public members: the `Logger` short-hands
  (`v`, `d`, `f`, `c`, `i`, `w`, `e`, `wtf`) and the constructors of the sinks
  and the filters. The `public_member_api_docs` lint keeps it that way.
- ci: analyzer, formatting and workflow fixes, updated the GitHub Actions the
  workflows use and fixed the pana-score script.

## 1.0.2

- fix: export dev-log sink

## 1.0.0

- feat!: upgraded to dart v3

## 0.6.3

- marked mapMany as deprecated
 
## 0.6.2

- un-deprecated `PrintSink`
 
## 0.6.1

- fix: expose `IoLogSink`

## 0.6.0

- feat: added `IoLogSink`
- deprecated `PrintSink`
- fix: json log record parser would add stackTrace even when none is present
- fix: a bunch of tests

## 0.5.3

- feat: added formatList functions

## 0.5.2

- fix: json formatter threw on object and error
- ci stuff

## 0.5.0

- feat: added filters
- test: improved coverage
- ci: automated publish

## 0.2.0

- feat: added parse list to json log record parser

## 0.1.1

- fix: export stream log sink

## 0.1.0

- feat: added stream log sink

## 0.0.1

- Initial version.
