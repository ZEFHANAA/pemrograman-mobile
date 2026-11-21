import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/shopping_list_model.dart';

class FormProviderPage extends StatelessWidget {
  const FormProviderPage({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => DaftarBelanjaModel(),
        child: const _ShoppingDemo(title: 'Praktikum 3 · Form & Provider'),
      );
}

class _ShoppingDemo extends StatefulWidget {
  const _ShoppingDemo({required this.title});
  final String title;

  @override
  State<_ShoppingDemo> createState() => _ShoppingDemoState();
}

class _ShoppingDemoState extends State<_ShoppingDemo> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addItem() {
    if (!_formKey.currentState!.validate()) return;
    context.read<DaftarBelanjaModel>().add(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Nama barang', border: OutlineInputBorder()),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Nama barang wajib diisi' : null,
                    onFieldSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _addItem, child: const Text('Tambah')),
              ]),
            ),
          ),
          Expanded(child: Consumer<DaftarBelanjaModel>(
            builder: (context, model, _) {
              if (model.items.isEmpty) return const Center(child: Text('Daftar belanja masih kosong.'));
              return ListView.builder(
                itemCount: model.items.length,
                itemBuilder: (context, index) {
                  final item = model.items[index];
                  return CheckboxListTile(
                    value: item.isPurchased,
                    title: Text(item.name, style: TextStyle(decoration: item.isPurchased ? TextDecoration.lineThrough : null)),
                    onChanged: (_) => model.toggle(item.id),
                    secondary: IconButton(onPressed: () => model.remove(item.id), icon: const Icon(Icons.delete_outline)),
                  );
                },
              );
            },
          )),
        ]),
      );
}
