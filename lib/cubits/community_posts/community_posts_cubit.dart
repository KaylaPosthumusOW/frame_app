import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/models/community_post_model.dart';
import 'package:frameapp/stores/firebase/community_post_firebase_repository.dart';

part 'community_posts_state.dart';

class CommunityPostsCubit extends Cubit<CommunityPostsState> {
  final CommunityPostFirebaseRepository _communityPostFirebaseRepository = sl<CommunityPostFirebaseRepository>();

  CommunityPostsCubit() : super(const CommunityPostsInitial());

  Future<void> loadAllCommunityPosts() async {
    emit(LoadingCommunityPosts(state.mainCommunityPostState.copyWith(message: 'Loading community posts')));
    try {
      List<CommunityPostModel> communityPosts = await _communityPostFirebaseRepository.loadAllCommunityPosts();
      emit(LoadedCommunityPosts(state.mainCommunityPostState.copyWith(communityPosts: communityPosts, message: 'Loaded ${communityPosts.length} community posts')));
    } catch (error, stackTrace) {
      emit(CommunityPostError(state.mainCommunityPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> loadCommunityPostsForUser({required String ownerUid}) async {
    emit(LoadingCommunityPosts(state.mainCommunityPostState.copyWith(message: 'Loading community posts for user')));
    try {
      List<CommunityPostModel> communityPosts = await _communityPostFirebaseRepository.loadCommunityPostsForUser(ownerUid: ownerUid);
      emit(LoadedCommunityPosts(state.mainCommunityPostState.copyWith(communityPosts: communityPosts, message: 'Loaded ${communityPosts.length} community posts for user')));
    } catch (error, stackTrace) {
      emit(CommunityPostError(state.mainCommunityPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> createNewCommunityPost(CommunityPostModel newCommunityPost) async {
    emit(CreatingCommunityPost(state.mainCommunityPostState.copyWith(message: 'Adding new community post')));
    try {
      List<CommunityPostModel> communityPosts = List.from(state.mainCommunityPostState.communityPosts ?? []);
      CommunityPostModel communityPost = await _communityPostFirebaseRepository.createCommunityPost(newCommunityPost);
      communityPosts.add(communityPost);
      emit(CreatedCommunityPost(state.mainCommunityPostState.copyWith(communityPosts: communityPosts, message: 'New community post added', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(CommunityPostError(state.mainCommunityPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> updateCommunityPost(CommunityPostModel communityPost) async {
    emit(UpdatingCommunityPost(state.mainCommunityPostState.copyWith(message: 'Updating community post')));
    try {
      List<CommunityPostModel> communityPosts = List.from(state.mainCommunityPostState.communityPosts ?? []);
      CommunityPostModel updatedCommunityPost = await _communityPostFirebaseRepository.updateCommunityPost(communityPost);
      int index = communityPosts.indexWhere((p) => p.uid == updatedCommunityPost.uid);
      if (index != -1) {
        communityPosts[index] = updatedCommunityPost;
      }
      emit(UpdatedCommunityPost(state.mainCommunityPostState.copyWith(communityPosts: communityPosts, message: 'Community post updated')));
    } catch (error, stackTrace) {
      emit(CommunityPostError(state.mainCommunityPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> archiveCommunityPost(CommunityPostModel communityPost) async {
    emit(UpdatingCommunityPost(state.mainCommunityPostState.copyWith(message: 'Archiving community post')));
    try {
      CommunityPostModel archivedCommunityPost = await _communityPostFirebaseRepository.archiveCommunityPost(communityPost);
      List<CommunityPostModel> communityPosts = List.from(state.mainCommunityPostState.communityPosts ?? []);
      int index = communityPosts.indexWhere((p) => p.uid == archivedCommunityPost.uid);
      if (index != -1) {
        communityPosts[index] = archivedCommunityPost;
      }
      emit(UpdatedCommunityPost(state.mainCommunityPostState.copyWith(communityPosts: communityPosts, message: 'Community post archived')));
    } catch (error, stackTrace) {
      emit(CommunityPostError(state.mainCommunityPostState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }
}