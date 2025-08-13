part of 'community_posts_cubit.dart';

class MainCommunityPostState extends Equatable {
  final String? message;
  final String? errorMessage;
  final List<CommunityPostModel>? communityPosts;
  final CommunityPostModel? selectedCommunityPost;
  final List<CommunityPostModel>? reportedCommunityPosts;

  const MainCommunityPostState({
    this.message,
    this.errorMessage,
    this.communityPosts,
    this.selectedCommunityPost,
    this.reportedCommunityPosts,
  });

  @override
  List<Object?> get props => [
        message,
        errorMessage,
        communityPosts,
        selectedCommunityPost,
        reportedCommunityPosts,
      ];

  MainCommunityPostState copyWith({
    String? message,
    String? errorMessage,
    List<CommunityPostModel>? communityPosts,
    CommunityPostModel? selectedCommunityPost,
    List<CommunityPostModel>? reportedCommunityPosts,
  }) {
    return MainCommunityPostState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      communityPosts: communityPosts ?? this.communityPosts,
      selectedCommunityPost: selectedCommunityPost ?? this.selectedCommunityPost,
      reportedCommunityPosts: reportedCommunityPosts ?? this.reportedCommunityPosts,
    );
  }
}

class CommunityPostsState extends Equatable {
  final MainCommunityPostState mainCommunityPostState;

  const CommunityPostsState(this.mainCommunityPostState);

  @override
  List<Object> get props => [mainCommunityPostState];
}

class CommunityPostsInitial extends CommunityPostsState {
  const CommunityPostsInitial() : super(const MainCommunityPostState());
}

class LoadingCommunityPosts extends CommunityPostsState {
  const LoadingCommunityPosts(MainCommunityPostState mainCommunityPostState) : super(mainCommunityPostState);
}

class LoadedCommunityPosts extends CommunityPostsState {
  const LoadedCommunityPosts(MainCommunityPostState mainCommunityPostState) : super(mainCommunityPostState);
}

class LoadingCommunityPostsForUser extends CommunityPostsState {
  const LoadingCommunityPostsForUser(MainCommunityPostState mainCommunityPostState) : super(mainCommunityPostState);
}

class LoadedCommunityPostsForUser extends CommunityPostsState {
  const LoadedCommunityPostsForUser(MainCommunityPostState mainCommunityPostState) : super(mainCommunityPostState);
}

class LoadingReportedCommunityPosts extends CommunityPostsState {
  const LoadingReportedCommunityPosts(MainCommunityPostState mainCommunityPostState) : super(mainCommunityPostState);
}

class LoadedReportedCommunityPosts extends CommunityPostsState {
  const LoadedReportedCommunityPosts(MainCommunityPostState mainCommunityPostState) : super(mainCommunityPostState);
}

class CreatingCommunityPost extends CommunityPostsState {
  const CreatingCommunityPost(MainCommunityPostState mainCommunityPostState) : super(mainCommunityPostState);
}

class CreatedCommunityPost extends CommunityPostsState {
  const CreatedCommunityPost(MainCommunityPostState mainCommunityPostState) : super(mainCommunityPostState);
}

class UpdatingCommunityPost extends CommunityPostsState {
  const UpdatingCommunityPost(MainCommunityPostState mainCommunityPostState) : super(mainCommunityPostState);
}

class UpdatedCommunityPost extends CommunityPostsState {
  const UpdatedCommunityPost(MainCommunityPostState mainCommunityPostState) : super(mainCommunityPostState);
}

class CommunityPostError extends CommunityPostsState {
  final String stackTrace;

  const CommunityPostError(MainCommunityPostState mainCommunityPostState, {this.stackTrace = ''}) : super(mainCommunityPostState);

  @override
  List<Object> get props => [mainCommunityPostState, stackTrace];
}