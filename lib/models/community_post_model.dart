import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:frameapp/models/app_user_profile.dart';

class CommunityPostModel extends Equatable {
  final String? uid;
  final CommunityPostModel? communityPost;
  final AppUserProfile? owner;
  final Timestamp? createdAt;
  final bool? isReported;
  final bool? archived;

  const CommunityPostModel({
    this.uid,
    this.communityPost,
    this.owner,
    this.createdAt,
    this.isReported = false,
    this.archived = false,
  });

  @override
  List<Object?> get props => [uid, communityPost, owner, createdAt, isReported, archived];

  CommunityPostModel copyWith({
    String? uid,
    CommunityPostModel? communityPost,
    AppUserProfile? owner,
    Timestamp? createdAt,
    bool? isReported,
    bool? archived,
  }) {
    return CommunityPostModel(
      uid: uid ?? this.uid,
      communityPost: communityPost ?? this.communityPost,
      owner: owner ?? this.owner,
      createdAt: createdAt ?? this.createdAt,
      isReported: isReported ?? this.isReported,
      archived: archived ?? this.archived,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'communityPost': communityPost?.toMap(),
      'owner': owner?.toMap(),
      'createdAt': createdAt,
      'isReported': isReported ?? false,
      'archived': archived ?? false,
    };
  }
  factory CommunityPostModel.fromMap(Map<String, dynamic> map) {
    return CommunityPostModel(
      uid: map['uid'],
      communityPost: map['communityPost'] != null ? CommunityPostModel.fromMap(map['communityPost']) : null,
      owner: map['owner'] != null ? AppUserProfile.fromMap(map['owner']) : null,
      createdAt: map['createdAt'],
      isReported: map['isReported'] ?? false,
      archived: map['archived'] ?? false,
    );
  }
}