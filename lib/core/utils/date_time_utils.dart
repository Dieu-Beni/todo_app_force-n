import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }
  
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }
  
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.isNegative) {
      if (difference.inDays.abs() > 0) {
        return '${difference.inDays.abs()} day(s) ago';
      } else if (difference.inHours.abs() > 0) {
        return '${difference.inHours.abs()} hour(s) ago';
      } else if (difference.inMinutes.abs() > 0) {
        return '${difference.inMinutes.abs()} minute(s) ago';
      } else {
        return 'Just now';
      }
    } else {
      if (difference.inDays > 0) {
        return 'In ${difference.inDays} day(s)';
      } else if (difference.inHours > 0) {
        return 'In ${difference.inHours} hour(s)';
      } else if (difference.inMinutes > 0) {
        return 'In ${difference.inMinutes} minute(s)';
      } else {
        return 'Now';
      }
    }
  }
  
  static bool isOverdue(DateTime dateTime) {
    return dateTime.isBefore(DateTime.now());
  }
}
