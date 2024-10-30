

class TimetableEntry {
  final String id;
  final String day;
  final int period;
  final String subject;
  final String startTime;
  final String endTime;

  TimetableEntry({
    required this.id,
    required this.day,
    required this.period,
    required this.subject,
    required this.startTime,
    required this.endTime,
  });

  factory TimetableEntry.fromMap(Map<String, dynamic> map) {
    return TimetableEntry(
      id: map['id'] as String,
      day: map['day'] as String,
      period: map['period'] as int,
      subject: map['subject'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'period': period,
      'subject': subject,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
