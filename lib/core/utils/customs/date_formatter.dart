class DateFormatter {
  static const _monthNames = [
    '', // placeholder for 0 index
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  /// Format as "Month Year" e.g., "May 2021"
  static String monthYear(DateTime date) {
    return '${_monthNames[date.month]} ${date.year}';
  }

  /// Format as "dd Month yyyy HH:mm" e.g., "02 January 2026 14:30"
  static String fullDateTime(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0'); // ensure 2 digits
    String day = twoDigits(date.day);
    String hour = twoDigits(date.hour);
    String minute = twoDigits(date.minute);

    return '$day ${_monthNames[date.month]} ${date.year} $hour:$minute';
  }
}
