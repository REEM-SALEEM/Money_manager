import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ProvParse extends ChangeNotifier{
    //*Date Format
  String parseDate(DateTime date) {
    final formattedDate = DateFormat.MMMd().format(date);
    final splittedDate = formattedDate.split(' ');
    return '  ${splittedDate.last}\n ${splittedDate.first}';
  }

}