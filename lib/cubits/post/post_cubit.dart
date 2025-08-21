import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/models/post_model.dart';
import 'package:frameapp/stores/firebase/post_firebase_repository.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  
  final PostFirebaseRepository _postFirebaseRepository = sl<PostFirebaseRepository>();

  PostCubit() : super(const PostInitial());

  Map<DateTime, List<PostModel>> groupPostsByWeek(List<PostModel> posts) {
    Map<DateTime, List<PostModel>> weekMap = {};
    for (var post in posts) {
      if (post.createdAt == null) continue;
      final date = post.createdAt!.toDate();
      final weekStart = DateTime(date.year, date.month, date.day - (date.weekday - 1));
      final normalizedWeekStart = DateTime(weekStart.year, weekStart.month, weekStart.day);
      weekMap.putIfAbsent(normalizedWeekStart, () => []);
      weekMap[normalizedWeekStart]!.add(post);
    }
    return weekMap;
  }

  Future<void> loadTodaysFrame({required String ownerUid}) async {
    emit(LoadingTodaysFrame(state.mainPostState.copyWith(message: 'Loading today\'s frame')));
    try {
      PostModel? todaysFrame = await _postFirebaseRepository.loadTodaysFrame(ownerUid: ownerUid);
      emit(LoadedTodaysFrame(state.mainPostState.copyWith(todaysFrame: todaysFrame, message: 'Loaded today\'s frame')));
    } catch (error, stackTrace) {
      emit(PostError(state.mainPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> reportPost(PostModel post) async {
    emit(UpdatingPost(state.mainPostState.copyWith(message: 'Reporting post...')));
    try {
      PostModel reportedPost = await _postFirebaseRepository.updatePost(post.copyWith(isReported: true));
      List<PostModel> communityPosts = List.from(state.mainPostState.communityPosts ?? []);
      communityPosts.removeWhere((p) => p.uid == reportedPost.uid);
      emit(UpdatedPost(state.mainPostState.copyWith(communityPosts: communityPosts, message: 'Post reported')));
      await loadCommunityPosts();
    } catch (error, stackTrace) {
      emit(PostError(state.mainPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> approveReportedPost(PostModel post) async {
    emit(UpdatingPost(state.mainPostState.copyWith(message: 'Approving reported post...')));
    try {
      PostModel approvedPost = await _postFirebaseRepository.updatePost(post.copyWith(isArchived: false, isReported: false));
      List<PostModel> reportedPosts = List.from(state.mainPostState.reportedPosts ?? []);
      reportedPosts.removeWhere((p) => p.uid == approvedPost.uid);
      emit(UpdatedPost(state.mainPostState.copyWith(reportedPosts: reportedPosts, message: 'Reported post approved')));
      await loadReportedPosts();
    } catch (error, stackTrace) {
      emit(PostError(state.mainPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> archiveReportedPost(PostModel post) async {
    emit(UpdatingPost(state.mainPostState.copyWith(message: 'Archiving reported post...')));
    try {
      PostModel archivedPost = await _postFirebaseRepository.updatePost(post.copyWith(isArchived: true, isReported: false));
      List<PostModel> reportedPosts = List.from(state.mainPostState.reportedPosts ?? []);
      reportedPosts.removeWhere((p) => p.uid == archivedPost.uid);
      emit(UpdatedPost(state.mainPostState.copyWith(reportedPosts: reportedPosts, message: 'Reported post archived')));
      await loadReportedPosts();
    } catch (error, stackTrace) {
      emit(PostError(state.mainPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> loadAllPosts({required String ownerUid}) async {
    emit(LoadingPosts(state.mainPostState.copyWith(message: 'Loading prompts')));
    try {
      List<PostModel> posts = await _postFirebaseRepository.loadPostsForUser(ownerUid: ownerUid);
      emit(LoadedPosts(state.mainPostState.copyWith(posts: posts, message: 'Loaded ${posts.length} prompts')));
    } catch (error, stackTrace) {
      emit(PostError(state.mainPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> loadReportedPosts() async {
    emit(LoadingReportedPosts(state.mainPostState.copyWith(message: 'Loading reported prompts')));
    try {
      List<PostModel> reportedPosts = await _postFirebaseRepository.loadReportedPosts();
      emit(LoadedReportedPosts(state.mainPostState.copyWith(reportedPosts: reportedPosts, message: 'Loaded ${reportedPosts.length} reported prompts')));
    } catch (error, stackTrace) {
      emit(PostError(state.mainPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> loadCommunityPosts() async {
    emit(LoadingCommunityPosts(state.mainPostState.copyWith(message: 'Loading community prompts')));
    try {
      List<PostModel> communityPosts = await _postFirebaseRepository.loadCommunityPosts();
      emit(LoadedCommunityPosts(state.mainPostState.copyWith(communityPosts: communityPosts, message: 'Loaded ${communityPosts.length} community prompts')));
    } catch (error, stackTrace) {
      emit(PostError(state.mainPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> createNewPost(PostModel newPost) async {
    emit(CreatingPost(state.mainPostState.copyWith(message: 'Adding new prompt')));
    try {
      List<PostModel> posts = List.from(state.mainPostState.posts ?? []);
      PostModel post = await _postFirebaseRepository.createPost(newPost);
      posts.add(post);
      emit(CreatedPost(state.mainPostState.copyWith(posts: posts, message: 'New prompt added', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(PostError(state.mainPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> updatePost(PostModel post) async {
    emit(UpdatingPost(state.mainPostState.copyWith(message: 'Updating prompt')));
    try {
      List<PostModel> posts = List.from(state.mainPostState.posts ?? []);
      PostModel updatedPost = await _postFirebaseRepository.updatePost(post);
      int index = posts.indexWhere((p) => p.uid == updatedPost.uid);
      if (index != -1) {
        posts[index] = updatedPost;
      }
      emit(UpdatedPost(state.mainPostState.copyWith(posts: posts, message: 'Prompt updated')));
    } catch (error, stackTrace) {
      emit(PostError(state.mainPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  void setSelectedPost(PostModel selectedPost) {
    emit(LoadingPost(state.mainPostState.copyWith(message: 'Selecting prompt')));
    emit(LoadedPosts(state.mainPostState.copyWith(selectedPost: selectedPost)));
  }

  void unSelectPost() {
    emit(LoadingPost(state.mainPostState.copyWith(message: 'Selecting prompt')));
    emit(LoadedPosts(state.mainPostState.copyWithNull(selectedPost: null, posts: state.mainPostState.posts)));
  }

  Future<void> deletePost(PostModel post) async {
    emit(DeletingPost(state.mainPostState.copyWith(message: 'Deleting prompt')));
    try {
      List<PostModel> posts = List.from(state.mainPostState.posts ?? []);
      await _postFirebaseRepository.deletePost(post);
      posts.removeWhere((p) => p.uid == post.uid);
      emit(PostDeleted(state.mainPostState.copyWith(posts: posts, message: 'Prompt deleted')));
    } catch (error, stackTrace) {
      emit(PostError(state.mainPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }
}
