import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:frameapp/models/app_user_profile.dart';

class PromptModel extends Equatable{
  final String? uid;
  final String? promptText;
  final Timestamp? createdAt;
  final Timestamp? usedAt;
  final bool? isUsed;
  final bool? currentPrompt;
  final AppUserProfile? owner;
  final bool? isArchived;

  const PromptModel({this.uid, this.promptText, this.createdAt, this.usedAt, this.isUsed = false, this.owner, this.currentPrompt = false, this.isArchived = false});

  @override
  List<Object?> get props => [uid, promptText, createdAt, usedAt, isUsed, owner, currentPrompt, isArchived];

  PromptModel copyWith({
    String? uid,
    String? promptText,
    Timestamp? createdAt,
    Timestamp? usedAt,
    bool? isUsed,
    AppUserProfile? owner,
    bool? currentPrompt,
    bool? isArchived,
  }) {
    return PromptModel(
      uid: uid ?? this.uid,
      promptText: promptText ?? this.promptText,
      createdAt: createdAt ?? this.createdAt,
      usedAt: usedAt ?? this.usedAt,
      isUsed: isUsed ?? this.isUsed,
      owner: owner ?? this.owner,
      currentPrompt: currentPrompt ?? this.currentPrompt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'promptText': promptText,
      'createdAt': createdAt,
      'usedAt': usedAt,
      'isUsed': isUsed,
      'owner': owner?.toMap(),
      'currentPrompt': currentPrompt,
      'isArchived': isArchived,
    };
  }
  factory PromptModel.fromMap(Map<String, dynamic> map) {
    return PromptModel(
      uid: map['uid'],
      promptText: map['promptText'],
      createdAt: map['createdAt'],
      usedAt: map['usedAt'],
      isUsed: map['isUsed'],
      owner: map['owner'] != null ? AppUserProfile.fromMap(map['owner']) : null,
      currentPrompt: map['currentPrompt'],
      isArchived: map['isArchived'] ?? false,
    );
  }

}