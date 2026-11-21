class Post {
  const Post({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
      );
}

class PostComment {
  const PostComment({required this.id, required this.name, required this.email, required this.body});

  final int id;
  final String name;
  final String email;
  final String body;

  factory PostComment.fromJson(Map<String, dynamic> json) => PostComment(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        body: json['body'] as String,
      );
}
