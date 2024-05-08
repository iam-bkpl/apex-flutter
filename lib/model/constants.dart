// transaction.dart constants

/**
 * late String transactionId;
    late String transactionTitle;
    late String transactionDescription;
    late double transactionAmount;
    late String transactionDateTime;
 */
library;


import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class WalletTransactionConstants {
  static const String transactionTable = "WalletTransaction";
  static const String transactionId = "transactionId";
  static const String transactionTitle = "transactionTitle";
  static const String transactionAmount = "transactionAmount";
  static const String transactionDateTime = "transactionDateTime";
  static const String transactionDescription = "transactionDescription";
  static const String transactionType = "transactionType";
  static const Color leftBarColor = Color.fromRGBO(157, 195, 132, 1);
  static const Color rightBarColor = Color.fromRGBO(209, 109, 106, 1);
  static Color avgColor =
      Colors.blue.shade300;
  static const double barWidth = 10;

  static String formatDateTime(String iso8601String) {
    DateTime dateTime = DateTime.parse(iso8601String);
    String formattedDate = DateFormat.yMMMMd().format(dateTime);
    return formattedDate;
  }
}


