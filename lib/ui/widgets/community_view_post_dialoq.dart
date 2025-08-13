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
  final TextEditingController _noteController = TextEditingController();
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
        title: Text(
          'Community Post',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        bloc: _postCubit,
        builder: (context, state) {
          if(state.mainPostState.selectedPost == null) {
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
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: AppColors.limeGreen,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User:',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '${state.mainPostState.selectedPost?.owner?.name?.isNotEmpty == true ? state.mainPostState.selectedPost?.owner?.name : 'User'} ${state.mainPostState.selectedPost?.owner?.surname ?? ''}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                    if (state.mainPostState.selectedPost?.prompt?.promptText != null)
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: AppColors.framePurple,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prompt:',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.black, fontWeight: FontWeight.bold,),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              state.mainPostState.selectedPost!.prompt!.promptText!,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black),
                            ),
                          ],
                        ),
                      ),
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
                    const SizedBox(height: 16.0),
                    FrameTextField(
                      controller: _noteController,
                      maxLines: 3,
                      label: 'Your Note',
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: FrameButton(
                            type: ButtonType.secondary,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => _reportPostDialoq(),
                              );
                            },
                            label: 'Report',
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: FrameButton(
                            type: ButtonType.primary,
                            onPressed: () {
                              final updatedPost = state.mainPostState.selectedPost!.copyWith(
                                note: _noteController.text,
                                isCommunityPost: isCommunityPost,
                              );
                              _postCubit.updatePost(updatedPost);
                              Navigator.pop(context, true);
                            },
                            label: 'Update',
                          ),
                        ),
                      ],
                    )
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
