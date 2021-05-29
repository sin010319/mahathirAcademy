extension StringExtension on String {
  static String displayTimeAgoFromTimestamp(String timestamp) {
    final year = int.parse(timestamp.substring(0, 4));
    final month = int.parse(timestamp.substring(5, 7));
    final day = int.parse(timestamp.substring(8, 10));
    final hour = int.parse(timestamp.substring(11, 13));
    final minute = int.parse(timestamp.substring(14, 16));
    final seconds = (double.parse(timestamp.substring(17))).toInt();

    final DateTime videoDate =
        DateTime(year, month, day, hour, minute, seconds);
    final int checkDiffInMinutes =
        DateTime.now().difference(videoDate).inMinutes;
    final int diffInHours = DateTime.now().difference(videoDate).inHours;

    String timeAgo = '';
    String timeUnit = '';
    int timeValue = 0;

    if (checkDiffInMinutes < 1) {
      final diffInSeconds = DateTime.now().difference(videoDate).inSeconds;
      timeValue = diffInSeconds;
      timeUnit = 'second';
    } else {
      if (diffInHours < 1) {
        final diffInMinutes = DateTime.now().difference(videoDate).inMinutes;
        timeValue = diffInMinutes;
        timeUnit = 'minute';
      } else if (diffInHours < 24) {
        timeValue = diffInHours;
        timeUnit = 'hour';
      } else if (diffInHours >= 24 && diffInHours < 24 * 7) {
        timeValue = (diffInHours / 24).floor();
        timeUnit = 'day';
      } else if (diffInHours >= 24 * 7 && diffInHours < 24 * 30) {
        timeValue = (diffInHours / (24 * 7)).floor();
        timeUnit = 'week';
      } else if (diffInHours >= 24 * 30 && diffInHours < 24 * 12 * 30) {
        timeValue = (diffInHours / (24 * 30)).floor();
        timeUnit = 'month';
      } else {
        timeValue = (diffInHours / (24 * 365)).floor();
        timeUnit = 'year';
      }
    }

    timeAgo = timeValue.toString() + ' ' + timeUnit;
    timeAgo += timeValue > 1 ? 's' : '';

    return timeAgo + ' ago';
  }
}