import 'package:flutter/material.dart';

import '../data/post_api.dart';
import '../data/post_models.dart';

class PenggunaApiPage extends StatefulWidget {
  const PenggunaApiPage({super.key});

  @override
  State<PenggunaApiPage> createState() => _Praktikum4ApiPageState();
}

class _Praktikum4ApiPageState extends State<PenggunaApiPage> {
  final PostApi _api = PostApi();
  late Future<List<Post>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchPosts();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  void _reload() => setState(() => _future = _api.fetchPosts());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Praktikum 4 · FutureBuilder & REST API'),
          actions: [IconButton(onPressed: _reload, icon: const Icon(Icons.refresh), tooltip: 'Muat ulang')],
        ),
        body: FutureBuilder<List<Post>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _LoadError(message: '${snapshot.error}', onRetry: _reload);
            }
            final posts = snapshot.data ?? const <Post>[];
            if (posts.isEmpty) return const Center(child: Text('Tidak ada postingan.'));
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${post.id}')),
                  title: Text(post.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                );
              },
            );
          },
        ),
      );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 42),
              const SizedBox(height: 12),
              Text('Gagal mengambil data:\n$message', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Coba lagi')),
            ],
          ),
        ),
      );
}
