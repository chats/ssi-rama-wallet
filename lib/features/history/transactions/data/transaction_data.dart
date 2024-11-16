import 'package:sqflite/sqflite.dart';

const String tableTransaction = 'transactions';
const String columnId = '_id';
const String columnTitle = 'title';
const String columnDescription = 'description';
const String columnCreatedAt = 'created_at';

class Transaction {
  int? id;
  String title;
  String description;
  DateTime createdAt;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: title,
      columnDescription: description,
      columnCreatedAt: createdAt.toIso8601String(),
    };
    map[columnId] = id;
    return map;
  }

  Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  Transaction.fromMap(Map<String, Object?> map)
      : id = map[columnId] as int,
        title = map[columnTitle].toString(),
        description = map[columnDescription].toString(),
        createdAt = DateTime.parse(map[columnCreatedAt].toString()) {
    id = map[columnId] as int;
    title = map[columnTitle].toString();
    description = map[columnDescription].toString();
    createdAt = DateTime.parse(map[columnCreatedAt].toString());
  }
}

class TransactionProvider {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        create table $tableTransaction ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDescription text not null,
          $columnCreatedAt datetime not null)
        ''');
    });
  }

  Future<Transaction> insert(Transaction transaction) async {
    transaction.id = await db.insert(tableTransaction, transaction.toMap());
    return transaction;
  }

  Future<Transaction?> getById(int id) async {
    List<Map> maps = await db.query(tableTransaction,
        columns: [columnId, columnTitle, columnDescription, columnCreatedAt],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Transaction.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<List<Transaction>> getLatest(int count) async {
    List<Transaction> transactions = [];

    List<Map> maps = await db.query(tableTransaction,
        columns: [columnId, columnTitle, columnDescription, columnCreatedAt],
        orderBy: '$columnCreatedAt DESC',
        limit: count);

    if (maps.isNotEmpty) {
      //return Transaction.fromMap(maps.first as Map<String, Object?>);
      for (var element in maps) {
        transactions.add(Transaction.fromMap(element as Map<String, Object?>));
      }
    }
    return transactions;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableTransaction, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Transaction todo) async {
    return await db.update(tableTransaction, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
