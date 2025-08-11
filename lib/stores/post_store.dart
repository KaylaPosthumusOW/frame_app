
import 'package:frameapp/models/post_model.dart';

abstract class PostStore {
  Future<PostModel> createPost(PostModel newPost);
  Future<List<PostModel>> loadPostsForUser({required String ownerUid});
  Future<PostModel> updatePost(PostModel post);
  Future<void> deletePost(PostModel post);
  Future<List<PostModel>> loadPostsWithUsedPrompt();
  Future<List<PostModel>> loadPostsWithUsedPromptForUser({required String ownerUid});
}
