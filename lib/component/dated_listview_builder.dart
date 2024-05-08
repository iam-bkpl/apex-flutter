import 'package:flutter/material.dart';
import 'package:wallet_app/model/constants.dart';
import '../model/transaction.dart';
import 'custom_list_tile.dart';

class DatedListView extends StatelessWidget {

  List<WalletTransaction> transactionList = [];

  DatedListView(this.transactionList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(4),
          child: Text(
              WalletTransactionConstants.formatDateTime(transactionList[0].transactionDateTime.toString()),
            textAlign: TextAlign.start,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: transactionList.length,
          itemBuilder: (context, index) => CustomListTile(
            uuid: transactionList[index].transactionId,
              title: transactionList[index]
                  .transactionTitle,
              description: transactionList[index].transactionDescription,
              amount: transactionList[index]
                  .transactionAmount
                  .toString(),
              transactionType: transactionList[index].transactionType,
              onTap: () => {}),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }


}
