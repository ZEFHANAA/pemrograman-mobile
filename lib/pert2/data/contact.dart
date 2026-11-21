class Contact {
  const Contact({required this.name, required this.phone, required this.email});
  final String name;
  final String phone;
  final String email;
}

const sampleContacts = <Contact>[
  Contact(name: 'Alya Putri', phone: '0812-0000-0001', email: 'alya@example.com'),
  Contact(name: 'Bima Pratama', phone: '0812-0000-0002', email: 'bima@example.com'),
  Contact(name: 'Citra Lestari', phone: '0812-0000-0003', email: 'citra@example.com'),
  Contact(name: 'Danu Wijaya', phone: '0812-0000-0004', email: 'danu@example.com'),
  Contact(name: 'Eka Saputra', phone: '0812-0000-0005', email: 'eka@example.com'),
];
