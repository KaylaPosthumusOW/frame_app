import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/comment/comment_cubit.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/models/comment_model.dart';
import 'package:frameapp/ui/widgets/frame_button.dart';
import 'package:frameapp/ui/widgets/frame_extended_image.dart';
import 'package:frameapp/ui/widgets/frame_text_field.dart';

class CommunityViewPostDialoq extends StatefulWidget {
  const CommunityViewPostDialoq({super.key});

  @override
  State<CommunityViewPostDialoq> createState() => _CommunityViewPostDialoqState();
}

class _CommunityViewPostDialoqState extends State<CommunityViewPostDialoq> {
  final PostCubit _postCubit = sl<PostCubit>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final CommentCubit _commentCubit = sl<CommentCubit>();

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _reportedReasonController = TextEditingController();

  bool isCommunityPost = false;

  @override
  void initState() {
    super.initState();
    _noteController.text = _postCubit.state.mainPostState.selectedPost?.note ?? '';
    _commentCubit.getCommentsForPost(postUid: _postCubit.state.mainPostState.selectedPost?.uid ?? '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Widget _reportPostDialoq() {
    return BlocConsumer(
        bloc: _postCubit,
        listener: (context, state) {
          if (state is UpdatingPost) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reporting...', style: TextStyle(color: Colors.white)),
                    CircularProgressIndicator(color: Colors.white),
                  ],
                ),
                backgroundColor: Colors.black,
              ),
            );
          }

          if (state is UpdatedPost) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('The Post has been reported', style: TextStyle(color: Colors.black)),
                backgroundColor: AppColors.limeGreen,
              ),
            );
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          return AlertDialog(
            title: Text('Report Post', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.black)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FrameTextField(
                  controller: _reportedReasonController,
                  maxLines: 3,
                  isLight: true,
                  label: 'Reason for Reporting',
                ),
              ],
            ),
            actions: [
              FrameButton(
                type: ButtonType.outline,
                onPressed: () {
                  Navigator.pop(context);
                },
                label: 'Cancel',
              ),
              FrameButton(
                type: ButtonType.primary,
                onPressed: () {
                  if (_reportedReasonController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please provide a reason for reporting', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.white)),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (_reportedReasonController.text.isNotEmpty) {
                    _postCubit.reportPost(
                      _postCubit.state.mainPostState.selectedPost!.copyWith(
                        isReportedReason: _reportedReasonController.text,
                        isReportedBy: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile,
                        isReported: true,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                label: 'Report',
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: _postCubit.state.mainPostState.selectedPost?.owner?.profilePicture != null ? NetworkImage(_postCubit.state.mainPostState.selectedPost?.owner!.profilePicture! ?? '') : const AssetImage('assets/pngs/blank_profile_image.png') as ImageProvider,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${_postCubit.state.mainPostState.selectedPost?.owner?.name ?? ''} '
                '${_postCubit.state.mainPostState.selectedPost?.owner?.surname ?? ''}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: AppColors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.report, color: AppColors.lightPink),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _reportPostDialoq(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        bloc: _postCubit,
        builder: (context, state) {
          if (state.mainPostState.selectedPost == null) {
            return Center(
              child: Text(
                'No post selected',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          if (state.mainPostState.selectedPost != null) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.mainPostState.selectedPost?.imageUrl != null)
                      Container(
                        padding: const EdgeInsets.all(2.0),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: FrameExtendedimage(
                            url: state.mainPostState.selectedPost?.imageUrl,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Center(
                          child: Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      ),
                    Text(state.mainPostState.selectedPost?.prompt?.promptText ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.black), textAlign: TextAlign.center),
                    Offstage(
                      offstage: state.mainPostState.selectedPost!.note == null || state.mainPostState.selectedPost!.note!.isEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(color: Colors.grey[300], height: 30.0),
                          Text(
                            'Users Caption',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            state.mainPostState.selectedPost?.note ?? '',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[300], height: 30.0),
                    _buildCommentSection(),
                  ],
                ),
              ),
            );
          }
          return Container(child: Text('No post selected', style: Theme.of(context).textTheme.bodyLarge));
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.white.withValues(alpha: 0.2), width: 1.0)),
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
            color: AppColors.black,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  cursorColor: AppColors.white,
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Leave a comment here...',
                    hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: AppColors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: AppColors.framePurple),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                margin: const EdgeInsets.only(left: 8.0),
                decoration: BoxDecoration(
                  color: AppColors.framePurple,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    _commentCubit.createNewComment(CommentModel(
                      owner: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile,
                      post: _postCubit.state.mainPostState.selectedPost,
                      comment: _commentController.text,
                      createdAt: Timestamp.now(),
                    ));
                    _commentController.clear();
                  },
                  icon: Icon(Icons.send, color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return BlocConsumer<CommentCubit, CommentState>(
      bloc: _commentCubit,
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comments for Post',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 16.0),
            if (state.mainCommentState.allCommentsForPost!.isEmpty)
              Text(
                'Be the first to comment!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.mainCommentState.allCommentsForPost?.length ?? 0,
              itemBuilder: (context, index) {
                final comment = state.mainCommentState.allCommentsForPost![index];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: comment.owner?.profilePicture != null ? NetworkImage(comment.owner!.profilePicture!) : const AssetImage('assets/pngs/blank_profile_image.png') as ImageProvider,
                      ),
                      title: Text(comment.comment ?? '', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.slateGrey)),
                      subtitle: Text('${comment.owner?.name} ${comment.owner?.surname}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.black)),
                      trailing: Text(
                        comment.createdAt != null ? '${comment.createdAt!.toDate().hour}:${comment.createdAt!.toDate().minute}' : '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.slateGrey),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                      height: 1.0,
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
