import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet_app/model/constants.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {


  late Database database;

  Future open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory);
    String dbPath = p.join(documentsDirectory.path, "app.db");
    try {
      database = await openDatabase(
          dbPath,
          version: 1,
          onCreate: (Database database, int version) async {
            print("DB opened successfully!");
          }
      );
    } catch(e) {
      print("DB open failed: ${e.toString()}");
    } finally {
      database.isOpen ? print("DB OPEN SUCCESS") : print("DB NOT OPEN");
    }
    return;
  }

  Future createTxTable() async {

    // await database.execute('DROP TABLE ${WalletTransactionConstants.transactionTable}');

    await database.execute(
        '''
        CREATE TABLE IF NOT EXISTS ${WalletTransactionConstants.transactionTable} (
          ${WalletTransactionConstants.transactionId} TEXT PRIMARY KEY NOT NULL,
          ${WalletTransactionConstants.transactionTitle} TEXT NOT NULL,
          ${WalletTransactionConstants.transactionDescription} TEXT DEFAULT NULL,
          ${WalletTransactionConstants.transactionDateTime} TEXT NOT NULL,
          ${WalletTransactionConstants.transactionAmount} REAL NOT NULL,
          ${WalletTransactionConstants.transactionType} TEXT CHECK (${WalletTransactionConstants.transactionType} IN ('income','expense')) NOT NULL DEFAULT 'expense'
        );
        '''
    );

    print("Table created!");
    return;
  }

  Future close () async => database.close();
}