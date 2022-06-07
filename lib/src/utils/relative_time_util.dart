import 'package:intl/intl.dart';

class RelativeTimeUtil {
  static String getRelativeTime(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm:ss a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = 'Hace ${diff.inDays} día.';
      } else {
        time = 'Hace ${diff.inDays} días.';
      }
    } else {
      if (diff.inDays == 7) {
        time = 'Hace ${(diff.inDays / 7).floor()} semana.';
      } else {
        time = 'Hace ${(diff.inDays / 7).floor()} semanas.';
      }
    }
    return time;
  }
}
