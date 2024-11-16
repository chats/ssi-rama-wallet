import 'package:flutter/material.dart';

import '../../features/history/transactions/data/transaction_data.dart';
import '../../features/history/transactions/data/transaction_service.dart';

Widget popupConnectionMessage(dynamic payload) {
  final state = payload["state"];
  return Container(
      decoration: BoxDecoration(
          color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
      child: Builder(
        builder: (context) {
          if (state == "active") {
            Transaction transaction = Transaction(
                title: "Connected to ${payload["their_label"]}",
                description: "Connection ID ${payload["connection_id"]}",
                createdAt: DateTime.now(),
                id: 0);
            TransactionService.addTransaction(transaction);
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("You're connected to: "),
                  Text(
                    payload["their_label"]!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  )
                ],
              ),
            );
          } else {
            return Text(
              payload["state"]!,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            );
            //return const SizedBox.shrink();
          }
        },
      ));
}
