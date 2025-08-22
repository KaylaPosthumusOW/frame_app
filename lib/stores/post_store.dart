import 'package:frameapp/models/post_model.dart';

abstract class PostStore {
  Future<PostModel> createPost(PostModel newPost);
  Future<List<PostModel>> loadPostsForUser({required String ownerUid});
  Future<List<PostModel>> loadReportedPosts();
  Future<List<PostModel>> loadCommunityPosts();
  Future<PostModel> updatePost(PostModel post);
  Future<void> deletePost(PostModel post);
  Future<List<PostModel>> loadPostsWithUsedPrompt();
  Future<List<PostModel>> loadPostsWithUsedPromptForUser({required String ownerUid});
  Future<PostModel> removeReportedPost(PostModel post);
  Future<PostModel> approveReportedPost(PostModel post);
  Future<PostModel?> loadTodaysFrame({required String ownerUid});
  Future<List<PostModel>> loadUsersReportedPosts({required String ownerUid});
}
