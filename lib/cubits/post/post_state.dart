part of 'post_cubit.dart';


class MainPostState extends Equatable {
  final String? message;
  final String? errorMessage;
  final List<PostModel>? posts;
  final PostModel? selectedPost;
  final List<PostModel>? reportedPosts;
  final List<PostModel>? communityPosts;
  final PostModel? todaysFrame;

  const MainPostState({this.message, this.errorMessage, this.posts, this.selectedPost, this.reportedPosts, this.communityPosts, this.todaysFrame});

  @override
  List<Object?> get props => [message, errorMessage, posts, selectedPost, reportedPosts, communityPosts, todaysFrame];

  MainPostState copyWith({
    String? message,
    String? errorMessage,
    List<PostModel>? posts,
    PostModel? selectedPost,
    List<PostModel>? reportedPosts,
    List<PostModel>? communityPosts,
    PostModel? todaysFrame,
  }) {
    return MainPostState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      posts: posts ?? this.posts,
      selectedPost: selectedPost ?? this.selectedPost,
      reportedPosts: reportedPosts ?? this.reportedPosts,
      communityPosts: communityPosts ?? this.communityPosts,
      todaysFrame: todaysFrame ?? this.todaysFrame,
    );
  }

  MainPostState copyWithNull({
    String? message,
    String? errorMessage,
    List<PostModel>? posts,
    PostModel? selectedPost,
    List<PostModel>? reportedPosts,
  }) {
    return MainPostState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      posts: posts ?? this.posts,
      selectedPost: selectedPost ?? this.selectedPost,
      reportedPosts: reportedPosts ?? this.reportedPosts,
    );
  }
}

abstract class PostState extends Equatable {
  final MainPostState mainPostState;

  const PostState(this.mainPostState);

  @override
  List<Object> get props => [mainPostState];
}

class LoadingTodaysFrame extends PostState {
  const LoadingTodaysFrame(MainPostState mainPostState) : super(mainPostState);
}

class LoadedTodaysFrame extends PostState {
  const LoadedTodaysFrame(MainPostState mainPostState) : super(mainPostState);
}

class PostInitial extends PostState {
  const PostInitial() : super(const MainPostState());
}

class CreatingPost extends PostState {
  const CreatingPost(MainPostState mainPostState) : super(mainPostState);
}

class CreatedPost extends PostState {
  const CreatedPost(MainPostState mainPostState) : super(mainPostState);
}

class LoadingPost extends PostState {
  const LoadingPost(MainPostState mainPostState) : super(mainPostState);
}

class LoadingReportedPosts extends PostState {
  const LoadingReportedPosts(MainPostState mainPostState) : super(mainPostState);
}

class LoadingCommunityPosts extends PostState {
  const LoadingCommunityPosts(MainPostState mainPostState) : super(mainPostState);
}

class LoadedCommunityPosts extends PostState {
  const LoadedCommunityPosts(MainPostState mainPostState) : super(mainPostState);
}

class LoadedReportedPosts extends PostState {
  const LoadedReportedPosts(MainPostState mainPostState) : super(mainPostState);
}

class LoadedPost extends PostState {
  const LoadedPost(MainPostState mainPostState) : super(mainPostState);
}

class LoadingPosts extends PostState {
  const LoadingPosts(MainPostState mainPostState) : super(mainPostState);
}

class LoadedPosts extends PostState {
  const LoadedPosts(MainPostState mainPostState) : super(mainPostState);
}

class UpdatingPost extends PostState {
  const UpdatingPost(MainPostState mainPostState) : super(mainPostState);
}

class UpdatedPost extends PostState {
  const UpdatedPost(MainPostState mainPostState) : super(mainPostState);
}


class PostError extends PostState {
  final String? stackTrace;
  const PostError(super.mainPostState, {this.stackTrace});
}