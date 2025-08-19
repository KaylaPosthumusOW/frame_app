import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frameapp/models/comment_model.dart';
import 'package:frameapp/stores/comment_store.dart';
import 'package:get_it/get_it.dart';

class CommentFirebaseRepository implements CommentStore {
  static final FirebaseFirestore _firebaseFirestore = GetIt.instance<FirebaseFirestore>();

  final CollectionReference<CommentModel> _commentCollection = _firebaseFirestore.collection('comments').withConverter<CommentModel>(
    fromFirestore: (snapshot, _) => CommentModel.fromMap(snapshot.data() ?? {}),
    toFirestore: (map, _) => map.toMap(),
  );

  @override
  Future<CommentModel> createComment(CommentModel newComment) async {
    DocumentReference<CommentModel> reference = _commentCollection.doc(newComment.uid);
    await reference.set(newComment.copyWith(uid: reference.id), SetOptions(merge: true));
    return newComment.copyWith(uid: reference.id);
  }

  @override
  Future<void> deleteComment(String commentId) {
    // TODO: implement deleteComment
    throw UnimplementedError();
  }

  @override
  Future<List<CommentModel>> getCommentsForPost({required String postUid}) async {
    List<CommentModel> commentsForPosts = [];
    QuerySnapshot<CommentModel> query = await _commentCollection.where('post.uid', isEqualTo: postUid).orderBy('createdAt', descending: true).get();
    for (var doc in query.docs) {
      commentsForPosts.add(doc.data());
    }
    return commentsForPosts;
  }

  @override
  Future<CommentModel> updateComment(CommentModel updatedComment) {
    // TODO: implement updateComment
    throw UnimplementedError();
  }
}