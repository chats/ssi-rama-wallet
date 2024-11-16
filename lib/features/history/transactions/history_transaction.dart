import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data/transaction_data.dart';
import 'data/transaction_service.dart';

class HistoryTransaction extends StatelessWidget {
  const HistoryTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Card(
        child: FutureBuilder(
          future: TransactionService.getTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                return const Center(child: Text("No transactions found"));
              } else {
//                var tx = snapshot.data as Transactions;
//                print('data = ${tx.title}'); // List<Transaction>
                final transactions = snapshot.data as List<Transaction>;
                return ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Dismissible(
                      key: ValueKey(transactions[index]),
                      background: Container(
                        color: Theme.of(context).colorScheme.error,
                        child: Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.onError),
                      ),
                      child: ListTile(
                        title: Text(transaction.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.description,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(DateFormat.yMMMd()
                                .add_jm()
                                .format(transaction.createdAt)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
