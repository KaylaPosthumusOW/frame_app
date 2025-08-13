import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:frameapp/models/app_user_profile.dart';
import 'package:frameapp/models/prompt_model.dart';

class PostModel extends Equatable {
  final String? uid;
  final AppUserProfile? owner;
  final PromptModel? prompt;
  final String? imageUrl;
  final String? note;
  final Timestamp? createdAt;
  final bool? isReported;
  final AppUserProfile? isReportedBy;
  final String? isReportedReason;
  final bool? isCommunityPost;
  final bool? isArchived;

  const PostModel({this.uid, this.owner, this.prompt, this.imageUrl, this.note, this.createdAt, this.isReported = false, this.isCommunityPost = false, this.isArchived = false, this.isReportedBy, this.isReportedReason});

  @override
  List<Object?> get props => [uid, owner, prompt, imageUrl, note, createdAt, isReported, isCommunityPost, isArchived, isReportedBy, isReportedReason];

  PostModel copyWith({
    String? uid,
    AppUserProfile? owner,
    PromptModel? prompt,
    String? imageUrl,
    String? note,
    Timestamp? createdAt,
    bool? isReported,
    bool? isCommunityPost,
    bool? isArchived,
    AppUserProfile? isReportedBy,
    String? isReportedReason,
  }) {
    return PostModel(
      uid: uid ?? this.uid,
      owner: owner ?? this.owner,
      prompt: prompt ?? this.prompt,
      imageUrl: imageUrl ?? this.imageUrl,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      isReported: isReported ?? this.isReported,
      isCommunityPost: isCommunityPost ?? this.isCommunityPost,
      isArchived: isArchived ?? this.isArchived,
      isReportedBy: isReportedBy ?? this.isReportedBy,
      isReportedReason: isReportedReason ?? this.isReportedReason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'owner': owner?.toMap(),
      'prompt': prompt?.toMap(),
      'imageUrl': imageUrl,
      'note': note,
      'createdAt': createdAt,
      'isReported': isReported ?? false,
      'isCommunityPost': isCommunityPost ?? false,
      'isArchived': isArchived ?? false,
      'isReportedBy': isReportedBy?.toMap(),
      'isReportedReason': isReportedReason,
    };
  }
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uid: map['uid'],
      owner: map['owner'] != null ? AppUserProfile.fromMap(map['owner']) : null,
      prompt: map['prompt'] != null ? PromptModel.fromMap(map['prompt']) : null,
      imageUrl: map['imageUrl'],
      note: map['note'],
      createdAt: map['createdAt'],
      isReported: map['isReported'] ?? false,
      isCommunityPost: map['isCommunityPost'] ?? false,
      isArchived: map['isArchived'] ?? false,
      isReportedBy: map['isReportedBy'] != null ? AppUserProfile.fromMap(map['isReportedBy']) : null,
      isReportedReason: map['isReportedReason'],
    );
  }
}