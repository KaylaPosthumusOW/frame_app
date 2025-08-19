import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:frameapp/models/app_user_profile.dart';
import 'package:frameapp/models/post_model.dart';

class CommentModel extends Equatable {
  final String? uid;
  final String? comment;
  final AppUserProfile? owner;
  final Timestamp? createdAt;
  final PostModel? post;

  const CommentModel({
    this.uid,
    this.comment,
    this.owner,
    this.createdAt,
    this.post,
  });

  @override
  List<Object?> get props => [uid, comment, owner, createdAt, post];

  CommentModel copyWith({
    String? uid,
    String? comment,
    AppUserProfile? owner,
    Timestamp? createdAt,
    PostModel? post,
  }) {
    return CommentModel(
      uid: uid ?? this.uid,
      comment: comment ?? this.comment,
      owner: owner ?? this.owner,
      createdAt: createdAt ?? this.createdAt,
      post: post ?? this.post,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'comment': comment,
      'owner': owner?.toMap(),
      'createdAt': createdAt,
      'post': post?.toMap(),
    };
  }
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      uid: map['uid'] as String?,
      comment: map['comment'] as String?,
      owner: map['owner'] != null ? AppUserProfile.fromMap(map['owner'] as Map<String, dynamic>) : null,
      createdAt: map['createdAt'] as Timestamp?,
      post: map['post'] != null ? PostModel.fromMap(map['post'] as Map<String, dynamic>) : null,
    );
  }
}