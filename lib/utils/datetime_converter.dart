import 'package:intl/intl.dart';

class DateConverted {
  static String getDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }

  static String getDay(int day) {
    switch (day) {
      case 1:
        return 'Lunedì';
      case 2:
        return 'Martedì';
      case 3:
        return 'Mercoledì';
      case 4:
        return 'Giovedì';
      case 5:
        return 'Venerdì';
      case 6:
        return 'Sabato';
      case 7:
        return 'Domenica';
      default: 
        return 'Lunedì';  
    }
  }

  static String getMonth(int month) {
    switch (month) {
      case 1:
        return 'Gennaio';
      case 2:
        return 'Febbraio';
      case 3:
        return 'Marzo';
      case 4:
        return 'Aprile';
      case 5:
        return 'Maggio';
      case 6:
        return 'Giugno';
      case 7:
        return 'Luglio';
      case 8:
        return 'Agosto';
      case 9:
        return 'Settembre';
      case 10:
        return 'Ottobre';
      case 11:
        return 'Novembre';
      case 12:
        return 'Dicembre';
      default: 
        return 'No Month';  
    }
  }

  static String getTime(int time) {
    switch (time) {
      case 0:
        return '9:00 AM';
      case 1:
        return '10:00 AM';
      case 2:
        return '11:00 AM';
      case 3:
        return '12:00 AM';
      case 4:
        return '13:00 PM';
      case 5:
        return '14:00 PM';
      case 6:
        return '15:00 PM';
      case 7:
        return '16:00 PM';
      case 8:
        return '17:00 PM';   
      default:
        return '9:00 AM';               
    }
  }
}