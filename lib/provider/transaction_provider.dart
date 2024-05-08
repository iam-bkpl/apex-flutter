import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet_app/helpers/db_helper.dart';
import 'package:wallet_app/model/daily_total.dart';
import 'package:wallet_app/model/transaction.dart';
import 'package:wallet_app/model/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionProvider with ChangeNotifier {
  TransactionProvider();

  late DatabaseHelper dbInstance;
  late BuildContext context;

  Future<void> initializeDatabase(BuildContext context) async {
    dbInstance = DatabaseHelper();
    this.context = context;
    await dbInstance.open();
    print("Db created, off to transaction table!");
    await dbInstance.createTxTable();

        /**
        print("Table created, adding transactions!");
        await addWalletTransaction(WalletTransaction.ulidInit('01HWT3YMWTJ6A32NDMF5FEDX73', 'Recharge', 'Recharged Ncell main SIM', '2024-04-26T14:04:44.606666', 500, 'expense'));
        await addWalletTransaction(WalletTransaction.ulidInit('01HX22RCN0AYDBZQEEQ7YRTVVG', 'Charger payback', 'Got paid for charger', '2024-04-26T14:04:44.606666', 800, 'income'));

        await addWalletTransaction(WalletTransaction.ulidInit('01HWT3YMWV7K7NCNXJBGHS82FM', 'Boba Tea from the bro', 'Bought boba @ Yo Boba', '2024-04-27T14:04:44.606666', 200, 'expense'));
        await addWalletTransaction(WalletTransaction.ulidInit('01HX22VRSYC6T8BQW7GGJKHY63', 'Book royalty', 'Got paid for book', '2024-04-27T14:04:44.606666', 800, 'income'));

        await addWalletTransaction(WalletTransaction.ulidInit('01HWT3YMWVP9TVFPG2ZSAQKZZK', 'Peri Peri Pizza', 'Pizza @ Downtown pizza', '2024-04-28T14:04:44.606666', 900, 'expense'));
        await addWalletTransaction(WalletTransaction.ulidInit('01HX22VZ2033JFBG21FP27P7PW', 'Petrol kickback', 'Got paid for petrol', '2024-04-28T14:04:44.606666', 800, 'income'));

        await addWalletTransaction(WalletTransaction.ulidInit('01HWT3YMWVVETRA0YN8FDK7NW8', 'Servicing', 'Changed bike carb', '2024-04-29T14:04:44.606666', 900, 'expense'));
        await addWalletTransaction(WalletTransaction.ulidInit('01HX22X5EEJ15YYM0E586N5A63', 'Paid for beer', 'Bro paid back for beer', '2024-04-29T14:04:44.606666', 1300, 'income'));

        await addWalletTransaction(WalletTransaction.ulidInit('01HWT3YMWWW5FTCV3JRP6BWP14', 'Futsal', 'Played futsal with the gang', '2024-04-30T14:04:44.606666', 400, 'expense'));
        await addWalletTransaction(WalletTransaction.ulidInit('01HX22Z1EZW5K9MDYSNPWQ8AHW', 'Futsal payback', 'Bro ko futsal haldeko firta', '2024-04-30T14:04:44.606666', 900, 'income'));

        await addWalletTransaction(WalletTransaction.ulidInit('01HX233DTZBH8CSRY5Y1SPRYZ5', 'Thakali dinner', 'Daura ma masu bhat', '2024-04-31T14:04:44.606666', 600, 'expense'));
        await addWalletTransaction(WalletTransaction.ulidInit('01HWT49YWRQ48TRRWD3ZQ7DCA3', 'Bro paid', 'Bro paid back in full', '2024-04-31T14:04:44.606666', 1000, 'income'));

        await addWalletTransaction(WalletTransaction.ulidInit('01HWT4A3G9XXBQK2JXAXFA0S10', 'Pizza payback', 'Bhai le pizza ko tireko', '2024-04-01T14:04:44.606666', 700, 'income'));
        await addWalletTransaction(WalletTransaction.ulidInit('01HX237Z4PNH962KCHE1SPJ9EB', 'Chiya', 'Patan ma chiya khayeko', '2024-04-01T14:04:44.606666', 350, 'expense'));
        **/
    //await addWalletTransaction(WalletTransaction.ulidInit('01HWT3YMWVP9TVFPG2ZSAQKZZK', 'Peri Peri Pizza', 'Pizza @ Downtown pizza', '2024-04-28T14:04:44.606666', 900, 'expense'));

    await getAllWalletTransactions();
    getAllTransactionsGroupedByDate();
    makeAllGroupData(this.context);
    return;
  }

  // this is the list that holds wallet transaction data for the whole application, and is a top level provider
  final List<WalletTransaction> _transactionList = [];

  // this list holds sorted list of transactions
  List<List<WalletTransaction>> _transactionListSortedByDate = [];

  // this method is required to pass number of list items to the listview builder along the entire app
  int get walletTransactionCount => _transactionList.length;

  // this method returns the number of date groups each transaction has
  int get dateGroupedWalletTransactionsCount =>
      _transactionListSortedByDate.length;

  List<WalletTransaction> get walletTransactions => _transactionList;

  List<List<WalletTransaction>> get datedWalletTransactionsList =>
      _transactionListSortedByDate;

  List<DailyTotal> barChartGroupData = [];
  List<String> dailyTotal = [];
  List<double> maxMedVal = [];

  // this method only saves the wallet transaction in database, doesn't affect the provider
  Future<WalletTransaction?> insert(
      WalletTransaction? walletTransaction, Database database) async {
    print("Attempting to insert tx in db!");
    int success = 0;
    if (walletTransaction != null) {
      print("insert() : about to insert since wallettx is not null");
      try {
        success = await database.insert(
            WalletTransactionConstants.transactionTable,
            walletTransaction.toMap());
      } catch (e) {
        print("Error: $e");
      }
      print("insertion success status: $success");
    }
    return success == 0 ? null : walletTransaction;
  }

  // this method only gets a wallet transaction in database, doesn't affect the provider
  Future<WalletTransaction?> getOne(
      String transactionId, Database database) async {
    List<Map<String, Object?>> maps = await database.query(
        WalletTransactionConstants.transactionTable,
        where: '${WalletTransactionConstants.transactionId} = ?',
        whereArgs: [transactionId]);
    if (maps.isNotEmpty) {
      return WalletTransaction.fromMap(maps.first);
    }
    return null;
  }

  // this method only gets all the wallet transactions from the database, no provider affected
  // TODO: Add Pagination Support to the wallet Transactions,
  // TODO: Add Fetch with date/month filters
  Future<List<WalletTransaction?>> getAll(Database database) async {
    List<WalletTransaction?> allWalletTransactionList = [];
    List<Map<String, Object?>> maps = await database
        .query(WalletTransactionConstants.transactionTable, where: '1 = 1');
    print("getAll(): map list length is: ${maps.length}");
    if (maps.isNotEmpty) {
      print("getAll(): Map is not empty");
      for (int i = 0; i < maps.length; ++i) {
        print("Map object: ${maps[i]}");
        allWalletTransactionList.add(WalletTransaction.fromMap(maps[i]));
      }
    }
    print("getAll(): Length: ${allWalletTransactionList.length}");
    return allWalletTransactionList;
  }

  // this method only deletes the wallet transaction in database, doesn't affect the provider
  Future<int> delete(String transactionId, Database database) async {
    int deleteStatus = await database.delete(
        WalletTransactionConstants.transactionTable,
        where: '${WalletTransactionConstants.transactionId} = ?',
        whereArgs: [transactionId]);
    return deleteStatus;
  }

  // this method only updates the wallet transaction in database, doesn't affect the provider
  Future<int> update(WalletTransaction transaction, Database database) async {
    return await database.update(
        WalletTransactionConstants.transactionTable, transaction.toMap(),
        where: '${WalletTransactionConstants.transactionId} = ?',
        whereArgs: [transaction.transactionId]);
  }

  // this method both adds the transaction to database, and on success updates the provider as well
  Future<int> addWalletTransaction(
      WalletTransaction? newWalletTransaction) async {
    print("Adding wallet transaction");
    WalletTransaction? thisWalletTransaction =
        await insert(newWalletTransaction, dbInstance.database);
    if (thisWalletTransaction != null) {
      print(
          "addWalletTransaction(WalletTransaction?) [transaction_provider.dart]:: Transaction added to database!");
      _transactionList.add(thisWalletTransaction);
      notifyListeners();
      return 1;
    } else {
      print(
          "addWalletTransaction(WalletTransaction?) [transaction_provider.dart]::Could not add transaction to database");
      return 0;
    }
  }

  // this method deletes the transaction from the database FIRST, and then updates the provider based on the deletion from database
  Future<int> deleteWalletTransaction(
      String? transactionId) async {
    if (transactionId != null) {
      int deletionStatus = await delete(
          transactionId, dbInstance.database);
      if (deletionStatus == 1) {
        _transactionList.removeWhere((element) =>
            element.transactionId == transactionId);
        notifyListeners();
        return 1;
      } else {
        return -1;
      }
    } else {
      return 0;
    }
  }

  // this method updates the transaction on the database FIRST, and then updates the provider based on the updation from database
  Future<int> updateWalletTransaction(
      WalletTransaction? thisWalletTransaction) async {
    if (thisWalletTransaction != null) {
      int updateStatus =
          await update(thisWalletTransaction, dbInstance.database);
      if (updateStatus > 0) {
        _transactionList.removeWhere((element) =>
            element.transactionId == thisWalletTransaction.transactionId);
        _transactionList.add(thisWalletTransaction);
        notifyListeners();
        return updateStatus;
      } else {
        return 0;
      }
    } else {
      return -1;
    }
  }

  Future<int> getAllWalletTransactions() async {
    List<WalletTransaction?> txList = await getAll(dbInstance.database);
    print(
        "getAllWalletTransactions(): list of transaction is ${txList.length} long!");
    _transactionList.removeRange(0, _transactionList.length);
    for (int i = 0; i < txList.length; ++i) {
      if (txList[i] != null) {
        print(
            "getAllWalletTransactions(): txList[i] (${txList[i]}) added to provider");
        _transactionList.add(txList[i]!);
      } else {
        print("getAllWalletTransactions(): txList[i] (${txList[i]}) is empty");
      }
    }
    notifyListeners();
    return _transactionList.length;
  }

  Future<int> getATransaction(String transactionId) async {
    WalletTransaction? transaction =
        await getOne(transactionId, dbInstance.database);
    if (transaction != null) {
      _transactionList.removeWhere(
          (element) => element.transactionId == transaction.transactionId);
      _transactionList.add(transaction);
      notifyListeners();
      return 1;
    }
    return 0;
  }

  int getAllTransactionsGroupedByDate() {
    // Create a map to store transactions grouped by date
    Map<DateTime, List<WalletTransaction>> groupedTransactions = {};

    // Iterate through all transactions and group them by date
    for (var transaction in _transactionList) {
      // Extract the date part from the transaction's DateTime
      DateTime date = DateTime(
          transaction.transactionDateTime.year,
          transaction.transactionDateTime.month,
          transaction.transactionDateTime.day);

      // Check if the date already exists in the map
      if (groupedTransactions.containsKey(date)) {
        // If the date exists, add the transaction to the existing list
        groupedTransactions[date]!.add(transaction);
      } else {
        // If the date does not exist, create a new list and add the transaction
        groupedTransactions[date] = [transaction];
      }
    }

    // Convert the map values (lists of transactions) to a list
    List<List<WalletTransaction>> result = groupedTransactions.values.toList();

    // Sort the list of lists by date in ascending order
    result.sort((a, b) =>
        a.first.transactionDateTime.compareTo(b.first.transactionDateTime));
    _transactionListSortedByDate.removeRange(
        0, _transactionListSortedByDate.length);
    _transactionListSortedByDate = [...(result.reversed.toList())];
    notifyListeners();

    return _transactionListSortedByDate.length;
  }

  List<String> calculateDailyTotals(List<WalletTransaction> transactions) {

    print("calculateDailyTotals(): init");
    // Map to store daily totals
    Map<String, double> expenseTotals = {};
    Map<String, double> incomeTotals = {};

    print("calculateDailyTotals(): Length of transaction list is: ${transactions.length}");
    // Calculate daily totals
    for (var transaction in transactions) {
      // Extract date in MM/dd format
      String dateKey =
          "${transaction.transactionDateTime.month.toString().padLeft(2, '0')}/${transaction.transactionDateTime.day.toString().padLeft(2, '0')}";

      // Calculate expense and income totals separately
      if (transaction.transactionType == TransactionType.expense) {
        print("calculateDailyTotals(): Transaction is expense");
        expenseTotals.update(
            dateKey, (value) => value + transaction.transactionAmount,
            ifAbsent: () => transaction.transactionAmount);
      } else {
        print("calculateDailyTotals(): Transaction is income");
        incomeTotals.update(
            dateKey, (value) => value + transaction.transactionAmount,
            ifAbsent: () => transaction.transactionAmount);
      }
    }

    // Convert totals to string format
    print("calculateDailyTotals(): init dailyTotals as a list (the thing that gets returned) ...");
    List<String> dailyTotals = [];
    expenseTotals.forEach((date, total) {
      double incomeTotal = incomeTotals[date] ?? 0.0;
      dailyTotals.add(date);
      dailyTotals.add("$total");
      dailyTotals.add("$incomeTotal");
      print("calculateDailyTotals(): Date is: $date, expense total is: $total, income total is: $incomeTotal");
    });
    print("calculateDailyTotals(): total length of returning data (dailyTotals) is ${dailyTotals.length}");
    print("calculateDailyTotals(): returning dailyTotals");
    notifyListeners();
    return dailyTotals;
  }

  List<double> calculateMaxAndMedian(List<List<WalletTransaction>> lists) {
    double maxSum = double.negativeInfinity;
    double medianSum = 0;

    // Iterate over each list of WalletTransaction objects
    for (List<WalletTransaction> transactionsList in lists) {
      // Calculate the sum of transaction amounts
      double sum = transactionsList.fold(0,
          (previous, transaction) => previous + transaction.transactionAmount);

      // Update the maximum sum if needed
      maxSum = sum > maxSum ? sum : maxSum;

      // Add the sum to calculate the median later
      medianSum += sum;
    }

    // Calculate the median
    medianSum /= lists.length;
    notifyListeners();
    return [maxSum, medianSum];
  }

  void makeAllGroupData(BuildContext context) async {
    print("makeAllGroupData() : creating DailyTotal list!");
    print("makeAllGroupData() : total dated transaction length: ${datedWalletTransactionsList.length}");
    barChartGroupData.removeRange(0, barChartGroupData.length);
    for (List<WalletTransaction> transactionList
        in datedWalletTransactionsList) {
      print("makeAllGroupData() : calculating dailytotal");
      dailyTotal = calculateDailyTotals(transactionList);
      print("makeAllGroupData() : dailyTOtal this round is: ${dailyTotal.length}");
      barChartGroupData.add(
        DailyTotal(
          dailyTotal[0],
          double.parse(dailyTotal[1]) ?? 0,
          double.parse(dailyTotal[2]) ?? 0,
        ),
      );
      print("makeAllGroupData() : added dailytotal to barchartgroupdata with length ${barChartGroupData.length}");
    }
    notifyListeners();
  }

  BarChartGroupData makeGroupData(int count, String x, double y1, double y2,
      Color leftBarColor, Color rightBarColor, double width) {
    return BarChartGroupData(
      barsSpace: 4,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: rightBarColor,
          width: width,
        ),
      ],
      x: count,
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text;

    if (value == 0) {
      text = '0';
    } else if (value == maxMedVal[1]) {
      text = '${maxMedVal[1]}';
    } else if (value == maxMedVal[0]) {
      text = '${maxMedVal[0]}';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }
}
