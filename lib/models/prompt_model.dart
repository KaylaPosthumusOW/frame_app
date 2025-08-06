import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PromptModel extends Equatable{
  final String? uid;
  final String? promptText;
  final Timestamp? createdAt;
  final Timestamp? usedAt;
  final bool? isUsed;

  const PromptModel({
    this.uid,
    this.promptText,
    this.createdAt,
    this.usedAt,
    this.isUsed,
  });

}