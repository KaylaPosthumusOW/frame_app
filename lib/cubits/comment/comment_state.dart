part of 'comment_cubit.dart';

class MainCommentState extends Equatable {
  final String? message;
  final String? errorMessage;
  final List<CommentModel>? allCommentsForPost;

  const MainCommentState({this.message, this.errorMessage, this.allCommentsForPost});

  @override
  List<Object?> get props => [message, errorMessage, allCommentsForPost];

  MainCommentState copyWith({
    String? message,
    String? errorMessage,
    List<CommentModel>? allCommentsForPost,
  }) {
    return MainCommentState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      allCommentsForPost: allCommentsForPost ?? this.allCommentsForPost,
    );
  }

  MainCommentState copyWithNull({
    String? message,
    String? errorMessage,
    List<CommentModel>? allCommentsForPost,
  }) {
    return MainCommentState(
      message: message,
      errorMessage: errorMessage,
      allCommentsForPost: allCommentsForPost,
    );
  }
}

abstract class CommentState extends Equatable {
  final MainCommentState mainCommentState;

  const CommentState(this.mainCommentState);

  @override
  List<Object> get props => [mainCommentState];
}

class CommentInitial extends CommentState {
  const CommentInitial() : super(const MainCommentState());
}

class CreatingComment extends CommentState {
  const CreatingComment(MainCommentState mainCommentState) : super(mainCommentState);
}

class CommentCreated extends CommentState {
  const CommentCreated(MainCommentState mainCommentState) : super(mainCommentState);
}

class LoadingAllCommentsForPost extends CommentState {
  const LoadingAllCommentsForPost(MainCommentState mainCommentState) : super(mainCommentState);
}

class AllCommentsForPostLoaded extends CommentState {
  const AllCommentsForPostLoaded(MainCommentState mainCommentState) : super(mainCommentState);
}

class CommentError extends CommentState {
  final String? stackTrace;
  const CommentError(super.mainCommentState, {this.stackTrace});
}