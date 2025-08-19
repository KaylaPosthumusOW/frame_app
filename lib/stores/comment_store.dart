import 'package:frameapp/models/comment_model.dart';

abstract class CommentStore {
  Future<List<CommentModel>> getCommentsForPost({required String postUid});
  Future<CommentModel> createComment(CommentModel newComment);
  Future<CommentModel> updateComment(CommentModel updatedComment);
  Future<void> deleteComment(String commentId);
}