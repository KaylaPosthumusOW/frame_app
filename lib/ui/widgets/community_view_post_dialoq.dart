import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
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
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Widget _reportPostDialoq() {
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
            if (_reportedReasonController.text.isNotEmpty) {
              _postCubit.updatePost(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: _postCubit.state.mainPostState.selectedPost?.owner?.profilePicture != null ? NetworkImage(_postCubit.state.mainPostState.selectedPost?.owner!.profilePicture! ?? '') : const AssetImage('assets/pngs/blank_profile_image.png') as ImageProvider,
            ),
            const SizedBox(width: 10),
            Text(
              '${_postCubit.state.mainPostState.selectedPost?.owner?.name} ${_postCubit.state.mainPostState.selectedPost?.owner?.surname}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.slateGrey),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comments',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: FrameTextField(
                                controller: _commentController,
                                label: 'Add a comment',
                                isLight: true,
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

                                  _commentController.clear();
                                },
                                icon: Icon(Icons.send, color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return Container(child: Text('No post selected', style: Theme.of(context).textTheme.bodyLarge));
        },
      ),
    );
  }
}
