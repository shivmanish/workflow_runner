String calculateTime({required DateTime date}) {
  String dateSeparatorText = '';

  DateTime now = DateTime.now();
  DateTime createdAt = date.toLocal();

  final monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  var weekdayNames = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  var diff = now.difference(createdAt);
  if (now.day == createdAt.day &&
      now.month == createdAt.month &&
      now.year == createdAt.year) {
    // Today
    dateSeparatorText = 'TODAY';
  } else {
    // Old record
    if (diff.inDays < 1) {
      dateSeparatorText = 'YESTERDAY';
    } else if (diff.inDays <= 7) {
      dateSeparatorText = weekdayNames[createdAt.weekday - 1];
    } else if (diff.inDays > 7 && diff.inDays <= 365) {
      var month = monthNames[createdAt.month - 1];
      dateSeparatorText = '${createdAt.day} ${month.toUpperCase()}';
    } else {
      // Older than 1 year
      dateSeparatorText =
          '${createdAt.month}-${createdAt.day}-${createdAt.year}';
    }
  }
  return dateSeparatorText;
}
