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

  const PostModel({this.uid, this.owner, this.prompt, this.imageUrl, this.note, this.createdAt, this.isReported = false});

  @override
  List<Object?> get props => [uid, owner, prompt, imageUrl, note, createdAt, isReported];

  PostModel copyWith({
    String? uid,
    AppUserProfile? owner,
    PromptModel? prompt,
    String? imageUrl,
    String? note,
    Timestamp? createdAt,
    bool? isReported,
  }) {
    return PostModel(
      uid: uid ?? this.uid,
      owner: owner ?? this.owner,
      prompt: prompt ?? this.prompt,
      imageUrl: imageUrl ?? this.imageUrl,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      isReported: isReported ?? this.isReported,
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
    );
  }
}