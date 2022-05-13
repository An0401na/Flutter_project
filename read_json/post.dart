import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}


@JsonSerializable()
class PostList{
  List<Post> ? list;

  PostList({
    required this.list
  });

  factory PostList.fromJson(Map<String, dynamic> json => _$PostListFromJson(json);
  Map<String,dynamic> toJson() => _$PostListToJson(this);
}