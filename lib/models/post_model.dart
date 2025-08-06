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

  const PostModel({this.uid, this.owner, this.prompt, this.imageUrl, this.note, this.createdAt});

  @override
  List<Object?> get props => [uid, owner, prompt, imageUrl, note, createdAt];

  PostModel copyWith({
    String? uid,
    AppUserProfile? owner,
    PromptModel? prompt,
    String? imageUrl,
    String? note,
    Timestamp? createdAt,
  }) {
    return PostModel(
      uid: uid ?? this.uid,
      owner: owner ?? this.owner,
      prompt: prompt ?? this.prompt,
      imageUrl: imageUrl ?? this.imageUrl,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
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
    );
  }
}