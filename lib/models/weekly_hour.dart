class WeeklyHour {
  int? id;
  DateTime day;
  double hours;

  WeeklyHour({required this.day, this.hours = 0.0, this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day.toIso8601String(),
      'hours': hours,
    };
  }

  static WeeklyHour fromMap(Map<String, dynamic> map) {
    return WeeklyHour(
      id: map['id'],
      day: DateTime.parse(map['day']),
      hours: map['hours'].toDouble(),
    );
  }

  @override
  String toString() {
    return 'WeeklyHour(id: ${id.toString()}, day: ${day.toString()}, hours: $hours)';
  }
}
