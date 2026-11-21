import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/expense_database.dart';

class ExpenseManagerPage extends StatefulWidget {
  const ExpenseManagerPage({super.key, required this.title});
  final String title;

  @override
  State<ExpenseManagerPage> createState() => _ExpenseManagerPageState();
}

class _ExpenseManagerPageState extends State<ExpenseManagerPage> {
  final _database = ExpenseDatabase.instance;
  final _preferences = SharedPreferencesAsync();
  late Future<List<Expense>> _expenses;
  String _currency = 'IDR';

  @override
  void initState() {
    super.initState();
    _expenses = _database.all();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final saved = await _preferences.getString('expense_currency') ?? 'IDR';
    if (mounted) setState(() => _currency = saved);
  }

  Future<void> _selectCurrency() async {
    final picked = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Mata uang tampilan'),
        children: ['IDR', 'USD'].map((value) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, value),
          child: Text(value),
        )).toList(),
      ),
    );
    if (picked == null) return;
    await _preferences.setString('expense_currency', picked);
    if (mounted) setState(() => _currency = picked);
  }

  Future<void> _refresh() async {
    final next = _database.all();
    setState(() => _expenses = next);
    await next;
  }

  Future<void> _editExpense({Expense? expense}) async {
    final titleController = TextEditingController(text: expense?.title ?? '');
    final amountController = TextEditingController(text: expense?.amount.toString() ?? '');
    final formKey = GlobalKey<FormState>();
    final values = await showDialog<(String, double)>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense == null ? 'Tambah Pengeluaran' : 'Ubah Pengeluaran'),
        content: Form(
          key: formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Keterangan'),
              validator: (value) => value == null || value.trim().isEmpty ? 'Isi keterangan' : null,
            ),
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Jumlah (angka)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) => double.tryParse((value ?? '').replaceAll(',', '.')) == null ? 'Masukkan jumlah yang valid' : null,
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(context, (
                titleController.text.trim(),
                double.parse(amountController.text.replaceAll(',', '.')),
              ));
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    titleController.dispose();
    amountController.dispose();
    if (values == null) return;
    final next = Expense(
      id: expense?.id,
      title: values.$1,
      amount: values.$2,
      date: DateTime.now().toIso8601String(),
    );
    if (expense == null) {
      await _database.insert(next);
    } else {
      await _database.update(next);
    }
    await _refresh();
  }

  Future<void> _deleteExpense(Expense expense) async {
    if (expense.id == null) return;
    await _database.delete(expense.id!);
    await _refresh();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [IconButton(onPressed: _selectCurrency, tooltip: 'Pengaturan mata uang', icon: const Icon(Icons.settings))],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _editExpense(),
          icon: const Icon(Icons.add),
          label: const Text('Pengeluaran'),
        ),
        body: FutureBuilder<List<Expense>>(
          future: _expenses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Center(child: Text('Database tidak dapat dibuka: ${snapshot.error}'));
            final expenses = snapshot.data ?? const <Expense>[];
            if (expenses.isEmpty) return const Center(child: Text('Belum ada pengeluaran. Tekan tombol Pengeluaran untuk menambah.'));
            final total = expenses.fold<double>(0, (sum, item) => sum + item.amount);
            return Column(children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: ListTile(
                  title: const Text('Total pengeluaran tersimpan di SQLite'),
                  subtitle: Text('$_currency ${total.toStringAsFixed(2)}'),
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final item = expenses[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
                      title: Text(item.title),
                      subtitle: Text('${item.date.substring(0, 10)} · $_currency ${item.amount.toStringAsFixed(2)}'),
                      trailing: Wrap(spacing: 0, children: [
                        IconButton(onPressed: () => _editExpense(expense: item), icon: const Icon(Icons.edit_outlined), tooltip: 'Ubah'),
                        IconButton(onPressed: () => _deleteExpense(item), icon: const Icon(Icons.delete_outline), tooltip: 'Hapus'),
                      ]),
                    );
                  },
                ),
              ),
            ]);
          },
        ),
      );
}
