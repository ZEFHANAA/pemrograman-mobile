import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class Expense {
  const Expense({this.id, required this.title, required this.amount, required this.date});

  final int? id;
  final String title;
  final double amount;
  final String date;

  Map<String, Object?> toMap() => {'id': id, 'title': title, 'amount': amount, 'date': date};

  factory Expense.fromMap(Map<String, Object?> map) => Expense(
        id: map['id'] as int,
        title: map['title'] as String,
        amount: (map['amount'] as num).toDouble(),
        date: map['date'] as String,
      );
}

class ExpenseDatabase {
  ExpenseDatabase._();
  static final ExpenseDatabase instance = ExpenseDatabase._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final root = await getDatabasesPath();
    _database = await openDatabase(
      path.join(root, 'pemmob_expenses.db'),
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE expenses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          date TEXT NOT NULL
        )
      '''),
    );
    return _database!;
  }

  Future<List<Expense>> all() async {
    final rows = await (await database).query('expenses', orderBy: 'date DESC, id DESC');
    return rows.map((row) => Expense.fromMap(Map<String, Object?>.from(row))).toList();
  }

  Future<int> insert(Expense expense) async =>
      (await database).insert('expenses', expense.toMap()..remove('id'));

  Future<int> update(Expense expense) async => (await database).update(
        'expenses',
        expense.toMap()..remove('id'),
        where: 'id = ?',
        whereArgs: [expense.id],
      );

  Future<int> delete(int id) async =>
      (await database).delete('expenses', where: 'id = ?', whereArgs: [id]);
}
