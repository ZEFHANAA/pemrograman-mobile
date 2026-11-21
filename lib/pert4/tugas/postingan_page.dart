import 'package:flutter/material.dart';

import '../data/post_api.dart';
import '../data/post_models.dart';

class DaftarPostinganPage extends StatefulWidget {
  const DaftarPostinganPage({super.key});

  @override
  State<DaftarPostinganPage> createState() => _DaftarPostinganPageState();
}

class _DaftarPostinganPageState extends State<DaftarPostinganPage> {
  final PostApi _api = PostApi();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _api.fetchPosts();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  void _reload() => setState(() => _postsFuture = _api.fetchPosts());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Tugas 4 · Daftar Postingan'),
          actions: [IconButton(onPressed: _reload, icon: const Icon(Icons.refresh), tooltip: 'Muat ulang')],
        ),
        body: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _PostError(message: '${snapshot.error}', onRetry: _reload);
            }
            final posts = snapshot.data ?? const <Post>[];
            if (posts.isEmpty) return const Center(child: Text('Tidak ada postingan.'));
            return ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${post.id}')),
                  title: Text(post.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(builder: (_) => DetailPostinganPage(post: post, api: _api)),
                  ),
                );
              },
            );
          },
        ),
      );
}

class DetailPostinganPage extends StatefulWidget {
  const DetailPostinganPage({super.key, required this.post, required this.api});

  final Post post;
  final PostApi api;

  @override
  State<DetailPostinganPage> createState() => _DetailPostinganPageState();
}

class _DetailPostinganPageState extends State<DetailPostinganPage> {
  late Future<List<PostComment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = widget.api.fetchComments(widget.post.id);
  }

  void _reloadComments() => setState(() => _commentsFuture = widget.api.fetchComments(widget.post.id));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Detail Postingan')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(widget.post.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(widget.post.body),
            const SizedBox(height: 24),
            Text('Komentar', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            FutureBuilder<List<PostComment>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) {
                  return _PostError(message: '${snapshot.error}', onRetry: _reloadComments);
                }
                final comments = snapshot.data ?? const <PostComment>[];
                if (comments.isEmpty) return const Text('Belum ada komentar.');
                return Column(
                  children: comments
                      .map((comment) => Card(
                            child: ListTile(
                              title: Text(comment.name),
                              subtitle: Text('${comment.email}\n\n${comment.body}'),
                              isThreeLine: true,
                            ),
                          ))
                      .toList(growable: false),
                );
              },
            ),
          ],
        ),
      );
}

class _PostError extends StatelessWidget {
  const _PostError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 40, color: Colors.red),
              const SizedBox(height: 12),
              Text('Gagal memuat data:\n$message', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
            ],
          ),
        ),
      );
}
