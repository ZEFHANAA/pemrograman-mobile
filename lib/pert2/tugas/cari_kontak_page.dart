import 'package:flutter/material.dart';

import '../data/contact.dart';
import '../praktikum/daftar_kontak_page.dart';

class CariKontakPage extends StatefulWidget {
  const CariKontakPage({super.key});

  @override
  State<CariKontakPage> createState() => _CariKontakPageState();
}

class _CariKontakPageState extends State<CariKontakPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final contacts = sampleContacts.where((contact) =>
      contact.name.toLowerCase().contains(_query.toLowerCase()) ||
      contact.phone.contains(_query) || contact.email.toLowerCase().contains(_query.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas 2 · Daftar Kontak')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (value) => setState(() => _query = value.trim()),
            decoration: const InputDecoration(labelText: 'Cari kontak', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
          ),
        ),
        Expanded(child: contacts.isEmpty
          ? const Center(child: Text('Kontak tidak ditemukan.'))
          : ListView.separated(
              itemCount: contacts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(contact.name[0])),
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push<void>(context, MaterialPageRoute<void>(
                    builder: (_) => DetailKontakPage(contact: contact),
                  )),
                );
              },
            )),
      ]),
    );
  }
}
