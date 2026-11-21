import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/shopping_list_model.dart';

class DaftarBelanjaPage extends StatelessWidget {
  const DaftarBelanjaPage({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => DaftarBelanjaModel(),
        child: const _ShoppingListPage(),
      );
}

class _ShoppingListPage extends StatefulWidget {
  const _ShoppingListPage();

  @override
  State<_ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<_ShoppingListPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<DaftarBelanjaModel>().add(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Tugas 3 · Daftar Belanja')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Barang yang ingin dibeli', border: OutlineInputBorder()),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Masukkan nama barang' : null,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(onPressed: _submit, icon: const Icon(Icons.add), label: const Text('Tambah')),
              ]),
            ),
          ),
          Expanded(child: Consumer<DaftarBelanjaModel>(
            builder: (context, model, _) {
              if (model.items.isEmpty) return const Center(child: Text('Belum ada barang. Tambahkan barang di atas.'));
              return ListView.separated(
                itemCount: model.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = model.items[index];
                  return CheckboxListTile(
                    value: item.isPurchased,
                    title: Text(item.name, style: TextStyle(decoration: item.isPurchased ? TextDecoration.lineThrough : null)),
                    subtitle: Text(item.isPurchased ? 'Sudah dibeli' : 'Belum dibeli'),
                    onChanged: (_) => model.toggle(item.id),
                    secondary: IconButton(onPressed: () => model.remove(item.id), icon: const Icon(Icons.delete_outline), tooltip: 'Hapus'),
                  );
                },
              );
            },
          )),
        ]),
      );
}
