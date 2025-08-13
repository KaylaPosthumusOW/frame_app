import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/models/post_model.dart';
import 'package:frameapp/stores/firebase/post_firebase_repository.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostFirebaseRepository _postFirebaseRepository = sl<PostFirebaseRepository>();

  PostCubit() : super(const PostInitial());

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

}