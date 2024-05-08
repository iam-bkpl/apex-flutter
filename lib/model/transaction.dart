import 'package:ulid/ulid.dart';
import 'constants.dart';

class WalletTransaction {
  late String transactionId;
  late String transactionTitle;
  late String? transactionDescription;
  late double transactionAmount;
  late DateTime transactionDateTime;
  late TransactionType transactionType;

  WalletTransaction.init(this.transactionTitle, this.transactionDescription,
      this.transactionAmount, this.transactionDateTime, this.transactionType) {
    transactionId = Ulid().toString();
  }

  WalletTransaction.ulidInit(this.transactionId, this.transactionTitle, this.transactionDescription,
      String transactionDateTimeSt, this.transactionAmount, String transactionType){
    transactionDateTime = DateTime.parse(transactionDateTimeSt);
    this.transactionType = TransactionType.fromType(transactionType) ?? TransactionType.income;
  }

  Map<String, Object?> toMap() {
    print("Converting wallettx to map");
    return <String, Object?> {
      WalletTransactionConstants.transactionId: transactionId,
      WalletTransactionConstants.transactionTitle: transactionTitle,
      WalletTransactionConstants.transactionDescription: transactionDescription,
      WalletTransactionConstants.transactionAmount: transactionAmount,
      WalletTransactionConstants.transactionDateTime: transactionDateTime.toIso8601String(),
      WalletTransactionConstants.transactionType: transactionType == TransactionType.income ? 'income' : 'expense'
    };
  }

  WalletTransaction.fromMap(Map<String, Object?> map) {
    transactionId = map[WalletTransactionConstants.transactionId].toString();
    transactionTitle = map[WalletTransactionConstants.transactionTitle].toString();
    transactionDateTime = DateTime.parse(map[WalletTransactionConstants.transactionDateTime].toString());
    transactionDescription = map[WalletTransactionConstants.transactionDescription].toString();
    transactionAmount = double.parse(map[WalletTransactionConstants.transactionAmount].toString());
    transactionType = TransactionType.fromType(map[WalletTransactionConstants.transactionType].toString()) ?? TransactionType.income;
  }

}

enum TransactionType {
  income,
  expense;

  static TransactionType? fromType(String type) {
    for(TransactionType transactionType in TransactionType.values) {
      if (transactionType.name == type) return transactionType;
    }
    return null;
  }

}