import 'package:flutter/foundation.dart';

import '../../../../constants/app_constants.dart';
import 'transaction_data.dart';

class TransactionService {
  static const DatabasePath = AppConstants.DATABASE;

  static Future<List<Object?>> getTransactions() async {
    final TransactionProvider provider = TransactionProvider();

    try {
      await provider.open(DatabasePath);
      final transactions = await provider.getLatest(200);
      return transactions;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    } finally {
      await provider.close();
    }
  }

  static Future<Object?> addTransaction(Transaction transaction) async {
    final TransactionProvider provider = TransactionProvider();

    try {
      await provider.open(DatabasePath);
      final result = await provider.insert(transaction);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    } finally {
      await provider.close();
    }
  }

  static Future<Object?> deleteTransaction(int id) async {
    final TransactionProvider provider = TransactionProvider();

    try {
      await provider.open(DatabasePath);
      final result = await provider.delete(id);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    } finally {
      await provider.close();
    }
  }
}
