import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frameapp/models/post_model.dart';
import 'package:frameapp/stores/post_store.dart';
import 'package:get_it/get_it.dart';

class PostFirebaseRepository implements PostStore {
  static final FirebaseFirestore _firebaseFirestore = GetIt.instance<FirebaseFirestore>();

  final CollectionReference<PostModel> _postCollection = _firebaseFirestore.collection('posts').withConverter<PostModel>(
    fromFirestore: (snapshot, _) => PostModel.fromMap(snapshot.data() ?? {}),
    toFirestore: (map, _) => map.toMap(),
  );

  @override
  Future<PostModel> createPost(PostModel newPost) async {
    DocumentReference<PostModel> reference = _postCollection.doc(newPost.uid);
    await reference.set(newPost.copyWith(uid: reference.id), SetOptions(merge: true));
    return newPost.copyWith(uid: reference.id);
  }

  @override
  Future<List<PostModel>> loadPostsForUser({required String ownerUid}) async {
    List<PostModel> posts = [];
    QuerySnapshot<PostModel> query = await _postCollection.where('owner.uid', isEqualTo: ownerUid).orderBy('createdAt', descending: true).get();
    for (var doc in query.docs) {
      posts.add(doc.data());
    }
    return posts;
  }



  @override
  Future<PostModel> updatePost(PostModel post) async {
    try {
      await _postCollection.doc(post.uid).set(post, SetOptions(merge: true));
      return post;
    } catch (e) {
      throw Exception('Failed to update client: $e');
    }
  }

  @override
  Future<void> deletePost(PostModel post) {
    if (post.uid != null && post.uid != '') {
      return _postCollection.doc(post.uid).delete();
    } else {
      throw Exception('Post UID is null or empty');
    }
  }
}
