import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/model/transaction.dart';
import 'package:wallet_app/provider/transaction_provider.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String amount;
  final String uuid;
  final String? description;
  final TransactionType transactionType;
  final VoidCallback onTap;

  const CustomListTile({
    super.key,
    required this.title,
    required this.uuid,
    this.description,
    required this.amount,
    required this.transactionType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: transactionType == TransactionType.income ? const Color.fromRGBO(220, 233, 213, 1) : const Color.fromRGBO(238, 205, 205, 1),
          shadowColor: Colors.grey.withOpacity(0.5),
          elevation: 1,
          margin: const EdgeInsets.all(2),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.black
                ),
              ),
              subtitle: Text(
                description ?? "No description",
                style: const TextStyle(
                  color: Colors.black
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${transactionType == TransactionType.income ? "+" : "-"}NRs. $amount",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () async {
                        await context.read<TransactionProvider>().deleteWalletTransaction(uuid);
                        if(context.mounted) await context.read<TransactionProvider>().getAllWalletTransactions();
                        if(context.mounted) context.read<TransactionProvider>().getAllTransactionsGroupedByDate();
                        if(context.mounted) context.read<TransactionProvider>().makeAllGroupData(context);
                      },
                      icon: const Icon(
                          Icons.delete
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
