import 'package:flutter/foundation.dart';

class FieldVisibilities extends ValueNotifier<FieldVisibilitiesData> {
  FieldVisibilities([
    FieldVisibilitiesData fields = const FieldVisibilitiesData(),
  ]) : super(fields);
}

class FieldVisibilitiesData {
  const FieldVisibilitiesData({
    this.icon = false,
    this.loggerName = true,
    this.time = true,
  });

  final bool icon;
  final bool loggerName;
  final bool time;

  FieldVisibilitiesData copyWith({
    bool? icon,
    bool? loggerName,
    bool? time,
  }) {
    return FieldVisibilitiesData(
      icon: icon ?? this.icon,
      loggerName: loggerName ?? this.loggerName,
      time: time ?? this.time,
    );
  }
}
