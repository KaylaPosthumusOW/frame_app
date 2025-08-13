import 'package:frameapp/models/community_post_model.dart';

abstract class CommunityPostsStore {
  Future<List<CommunityPostModel>> loadAllCommunityPosts();
  Future<List<CommunityPostModel>> loadCommunityPostsForUser({required String ownerUid});
  Future<CommunityPostModel> createCommunityPost(CommunityPostModel newCommunityPost);
  Future<CommunityPostModel> updateCommunityPost(CommunityPostModel communityPost);
  Future<CommunityPostModel> archiveCommunityPost(CommunityPostModel communityPost);
}