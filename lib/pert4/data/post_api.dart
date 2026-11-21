import 'dart:convert';

import 'package:http/http.dart' as http;

import 'post_models.dart';

class PostApi {
  PostApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/posts'))
        .timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat postingan (HTTP ${response.statusCode})');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List) throw const FormatException('Format daftar postingan tidak valid.');
    return decoded
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<List<PostComment>> fetchComments(int postId) async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/posts/$postId/comments'))
        .timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat komentar (HTTP ${response.statusCode})');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List) throw const FormatException('Format komentar tidak valid.');
    return decoded
        .map((item) => PostComment.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  void dispose() => _client.close();
}
