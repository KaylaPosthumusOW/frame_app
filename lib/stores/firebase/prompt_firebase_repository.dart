
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frameapp/models/prompt_model.dart';
import 'package:frameapp/stores/prompt_store.dart';
import 'package:get_it/get_it.dart';

class PromptFirebaseRepository implements PromptStore {
  static final FirebaseFirestore _firebaseFirestore = GetIt.instance<FirebaseFirestore>();

  final CollectionReference<PromptModel> _promptCollection = _firebaseFirestore.collection('prompts').withConverter<PromptModel>(
    fromFirestore: (snapshot, _) => PromptModel.fromMap(snapshot.data() ?? {}),
    toFirestore: (map, _) => map.toMap(),
  );

  @override
  Future<PromptModel> createPrompt(PromptModel newPrompt) async {
    DocumentReference<PromptModel> reference = _promptCollection.doc(newPrompt.uid);
    await reference.set(newPrompt.copyWith(uid: reference.id), SetOptions(merge: true));
    return newPrompt.copyWith(uid: reference.id);
  }

  @override
  Future<List<PromptModel>> loadPrompts({required String ownerUid}) async {
    List<PromptModel> prompts = [];
    QuerySnapshot<PromptModel> query = await _promptCollection.where('owner.uid', isEqualTo: ownerUid).orderBy('createdAt', descending: true).get();
    for (var doc in query.docs) {
      prompts.add(doc.data());
    }
    return prompts;
  }
  @override
  Future<PromptModel> getCurrentPrompt() async {
    QuerySnapshot<PromptModel> querySnapshot = await _promptCollection.where('isUsed', isEqualTo: true).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      throw Exception('No current post found');
    }
  }

  @override
  Future<PromptModel> updatePrompt(PromptModel prompt) async {
    try {
      await _promptCollection.doc(prompt.uid).set(prompt, SetOptions(merge: true));
      return prompt;
    } catch (e) {
      throw Exception('Failed to update client: $e');
    }
  }



}