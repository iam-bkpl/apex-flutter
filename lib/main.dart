import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/component/bar_chart_widget.dart';
import 'package:wallet_app/component/dated_listview_builder.dart';
import 'package:wallet_app/model/transaction.dart';
import 'package:wallet_app/pages/transaction_form.dart';
import 'package:wallet_app/provider/transaction_provider.dart';


void main() async {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => TransactionProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WalletApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: context.read<TransactionProvider>().initializeDatabase(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const MyHomePage(title: 'Wallet App');
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Initializing..'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
            // return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void addWalletTransaction(WalletTransaction? walletTransaction) async {
    await context.read<TransactionProvider>().addWalletTransaction(walletTransaction);
    if(context.mounted) await context.read<TransactionProvider>().getAllWalletTransactions();
    if(context.mounted) context.read<TransactionProvider>().getAllTransactionsGroupedByDate();
    if(context.mounted) context.read<TransactionProvider>().makeAllGroupData(context);

  }

  @override
  Widget build(BuildContext context) {
    // _initializeTransactions();
    print(
        "build(): ${context.read<TransactionProvider>().walletTransactionCount}");

    print("build() length of barchartgroupdata is: ${context.read<TransactionProvider>().barChartGroupData.length}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: BarChartWidget(dailyTotals: context.watch<TransactionProvider>().barChartGroupData)),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child:
                  context.watch<TransactionProvider>().walletTransactionCount !=
                          0
                      ? ListView.builder(
                          itemCount: context
                              .watch<TransactionProvider>()
                              .dateGroupedWalletTransactionsCount,
                          itemBuilder: (context, index) => DatedListView(context
                              .watch<TransactionProvider>()
                              .datedWalletTransactionsList[index]))
                      : const Center(child: Text('Empty list')),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.deepPurple,
        ),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return TransactionForm(addWalletTransaction: addWalletTransaction);
              }
          );
        },
      ),
    );
  }
}
