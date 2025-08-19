import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/models/comment_model.dart';
import 'package:frameapp/stores/firebase/comment_firebase_repository.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentFirebaseRepository _commentFirebaseRepository = sl<CommentFirebaseRepository>();

  CommentCubit() : super(const CommentInitial());

  Future<void> createNewComment(CommentModel newComment) async {
    emit(CreatingComment(state.mainCommentState.copyWith(message: 'Adding new prompt')));
    try {
      List<CommentModel> comments = List.from(state.mainCommentState.allCommentsForPost ?? []);
      CommentModel comment = await _commentFirebaseRepository.createComment(newComment);
      comments.add(comment);
      emit(CommentCreated(state.mainCommentState.copyWith(allCommentsForPost: comments, message: 'New prompt added', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(CommentError(state.mainCommentState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }

  Future<void> getCommentsForPost({required String postUid}) async {
    emit(LoadingAllCommentsForPost(state.mainCommentState.copyWith(message: 'Loading comments')));
    try {
      List<CommentModel> comments = await _commentFirebaseRepository.getCommentsForPost(postUid: postUid);
      emit(AllCommentsForPostLoaded(state.mainCommentState.copyWith(allCommentsForPost: comments, message: 'Comments loaded', errorMessage: '')));
    } catch (error, stackTrace) {
      emit(CommentError(state.mainCommentState.copyWith(message: '', errorMessage: error.toString()), stackTrace: stackTrace.toString()));
    }
  }
}