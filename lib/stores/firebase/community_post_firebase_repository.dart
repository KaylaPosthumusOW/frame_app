import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frameapp/models/community_post_model.dart';
import 'package:frameapp/stores/community_posts_store.dart';
import 'package:get_it/get_it.dart';

class CommunityPostFirebaseRepository extends CommunityPostsStore {
  static final FirebaseFirestore _firebaseFirestore = GetIt.instance<FirebaseFirestore>();

  final CollectionReference<CommunityPostModel> _communityPostFirebaseRepository = _firebaseFirestore.collection('communityPosts').withConverter<CommunityPostModel>(
    fromFirestore: (snapshot, _) => CommunityPostModel.fromMap(snapshot.data() ?? {}),
    toFirestore: (map, _) => map.toMap(),
  );

  @override
  Future<CommunityPostModel> createCommunityPost(CommunityPostModel newCommunityPost) async {
    DocumentReference<CommunityPostModel> reference = _communityPostFirebaseRepository.doc(newCommunityPost.uid);
    await reference.set(newCommunityPost.copyWith(uid: reference.id), SetOptions(merge: true));
    return newCommunityPost.copyWith(uid: reference.id);
  }

  @override
  Future<List<CommunityPostModel>> loadAllCommunityPosts() async {
    List<CommunityPostModel> allCommunityPosts = [];
    QuerySnapshot<CommunityPostModel> query = await _communityPostFirebaseRepository.orderBy('createdAt', descending: true).get();
    for (var doc in query.docs) {
      allCommunityPosts.add(doc.data());
    }
    return allCommunityPosts;
  }

  @override
  Future<List<CommunityPostModel>> loadCommunityPostsForUser({required String ownerUid}) async {
    List<CommunityPostModel> communityPosts = [];
    QuerySnapshot<CommunityPostModel> query = await _communityPostFirebaseRepository.where('owner.uid', isEqualTo: ownerUid).orderBy('createdAt', descending: true).get();
    for (var doc in query.docs) {
      communityPosts.add(doc.data());
    }
    return communityPosts;
  }

  @override
  Future<CommunityPostModel> updateCommunityPost(CommunityPostModel communityPost) {
    try {
      return _communityPostFirebaseRepository.doc(communityPost.uid).set(communityPost, SetOptions(merge: true)).then((_) => communityPost);
    } catch (e) {
      throw Exception('Failed to update community post: $e');
    }
  }

  @override
  Future<CommunityPostModel> archiveCommunityPost(CommunityPostModel communityPost) {
    if (communityPost.uid != null && communityPost.uid != '') {
      return _communityPostFirebaseRepository.doc(communityPost.uid).set(
        communityPost.copyWith(archived: true),
        SetOptions(merge: true),
      ).then((_) => communityPost.copyWith(archived: true));
    } else {
      throw Exception('Community Post UID is null or empty');
    }
  }
}