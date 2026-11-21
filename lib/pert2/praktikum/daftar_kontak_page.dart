import 'package:flutter/material.dart';

import '../data/contact.dart';

class DaftarKontakPage extends StatelessWidget {
  const DaftarKontakPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Praktikum 2 · ListView & Navigasi')),
        body: ListView.builder(
          itemCount: sampleContacts.length,
          itemBuilder: (context, index) {
            final contact = sampleContacts[index];
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
        ),
      );
}

class DetailKontakPage extends StatelessWidget {
  const DetailKontakPage({super.key, required this.contact});
  final Contact contact;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(contact.name)),
        body: ListView(children: [
          ListTile(leading: const Icon(Icons.phone), title: const Text('Telepon'), subtitle: Text(contact.phone)),
          ListTile(leading: const Icon(Icons.email), title: const Text('Email'), subtitle: Text(contact.email)),
        ]),
      );
}
