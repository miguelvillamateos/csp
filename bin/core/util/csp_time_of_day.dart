///
/// Clase para gestión de momento del día independiente de la fecha
///
part of '../csp.dart';

class CspTimeOfDay extends Equatable implements Comparable<CspTimeOfDay> {
  final int hour;
  final int minute;
  final int seconds;

  const CspTimeOfDay(
      {required this.hour, required this.minute, required this.seconds});

  CspTimeOfDay.fromDateTime({required DateTime dateTime})
      : this(
            hour: dateTime.hour,
            minute: dateTime.minute,
            seconds: dateTime.second);

  CspTimeOfDay.now() : this.fromDateTime(dateTime: DateTime.now());

  bool isValid() {
    return (hour >= 0 && hour <= 23) &&
        (minute >= 0 && minute <= 59) &&
        (seconds >= 0 && seconds <= 59);
  }

  @override
  List<Object?> get props => [hour, minute, seconds];

  @override
  int compareTo(CspTimeOfDay other) {
    if (hour != other.hour) return hour.compareTo(other.hour);
    return minute.compareTo(other.minute);
  }

  @override
  String toString() {
    return " $hour:$minute:$seconds";
  }
}
