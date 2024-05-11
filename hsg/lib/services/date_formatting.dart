import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  return '${formatDate(dateTime)} at ${formatTime(dateTime)}';
}

String formatDate(DateTime dateTime) {
  return DateFormat.yMMMd().format(dateTime);
}

String formatTime(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
}

String formatText(String text, int maxlength) {
  String returnText = text.split('\n')[0];
  if (returnText.length <= maxlength) {
    return returnText;
  }
  return returnText.substring(0, maxlength - 3) + '...';
}


