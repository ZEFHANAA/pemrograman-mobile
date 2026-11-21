import 'package:flutter/material.dart';

import '../data/health_service.dart';

class StatusServerPage extends StatefulWidget {
  const StatusServerPage({super.key, this.title = 'Status TabungKu Cloud'});
  final String title;

  @override
  State<StatusServerPage> createState() => _StatusServerPageState();
}

class _StatusServerPageState extends State<StatusServerPage> {
  final HealthService _service = HealthService();
  late Future<ServerHealth> _future;
  String _url = defaultApiUrl;

  @override
  void initState() {
    super.initState();
    _future = _service.check();
    _load();
  }

  Future<void> _load() async {
    final url = await _service.getApiUrl();
    if (mounted) setState(() => _url = url);
    if (!mounted) return;
    setState(() => _future = _service.check());
  }

  void _checkAgain() => setState(() => _future = _service.check());

  Future<void> _editUrl() async {
    final controller = TextEditingController(text: _url);
    final formKey = GlobalKey<FormState>();
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alamat API'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'URL backend', hintText: 'http://10.0.2.2:8000'),
            keyboardType: TextInputType.url,
            validator: (input) {
              final uri = Uri.tryParse((input ?? '').trim());
              if (uri == null || !uri.hasScheme || uri.host.isEmpty || !['http', 'https'].contains(uri.scheme)) {
                return 'Masukkan URL http/https yang valid';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(context, controller.text.trim());
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null) return;
    await _service.saveApiUrl(value);
    if (!mounted) return;
    setState(() {
      _url = value.replaceAll(RegExp(r'/+$'), '');
      _future = _service.check();
    });
  }

  Widget _statusTile({required String title, required bool? online, String? subtitle}) {
    final color = online == null ? Colors.grey : online ? Colors.green : Colors.red;
    final label = online == null ? 'Belum diperiksa' : online ? 'Terhubung' : 'Tidak terhubung';
    return Card(
      child: ListTile(
        leading: Icon(online == null ? Icons.help_outline : online ? Icons.check_circle : Icons.error, color: color),
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle),
        trailing: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(onPressed: _editUrl, icon: const Icon(Icons.settings_ethernet), tooltip: 'Ubah alamat API'),
            IconButton(onPressed: _checkAgain, icon: const Icon(Icons.refresh), tooltip: 'Periksa lagi'),
          ],
        ),
        body: FutureBuilder<ServerHealth>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) {
              return ListView(padding: const EdgeInsets.all(16), children: [
                _statusTile(title: 'API', online: false, subtitle: '${snapshot.error}'),
                _statusTile(title: 'Database MySQL', online: null),
                Text('Alamat: $_url', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton.icon(onPressed: _checkAgain, icon: const Icon(Icons.refresh), label: const Text('Periksa lagi')),
              ]);
            }
            final result = snapshot.data!;
            return ListView(padding: const EdgeInsets.all(16), children: [
              _statusTile(title: 'API FastAPI', online: result.apiAvailable, subtitle: _url),
              _statusTile(
                title: 'Database MySQL',
                online: result.databaseAvailable,
                subtitle: result.mysqlVersion ?? result.detail,
              ),
              Card(child: ListTile(leading: const Icon(Icons.schedule), title: const Text('Waktu server'), subtitle: Text(result.serverTime))),
              Card(child: ListTile(leading: const Icon(Icons.speed), title: const Text('Latensi'), subtitle: Text('${result.latency.inMilliseconds} ms'))),
              const SizedBox(height: 12),
              FilledButton.icon(onPressed: _checkAgain, icon: const Icon(Icons.refresh), label: const Text('Periksa lagi')),
            ]);
          },
        ),
      );
}
