class LogFieldVisibilities {
  const LogFieldVisibilities({
    this.icon = false,
    this.loggerName = true,
    this.time = true,
  });

  final bool icon;
  final bool loggerName;
  final bool time;

  LogFieldVisibilities copyWith({
    bool? icon,
    bool? loggerName,
    bool? time,
  }) {
    return LogFieldVisibilities(
      icon: icon ?? this.icon,
      loggerName: loggerName ?? this.loggerName,
      time: time ?? this.time,
    );
  }
}
