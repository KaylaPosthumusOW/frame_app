import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/models/post_model.dart';
import 'package:frameapp/ui/widgets/frame_button.dart';
import 'package:frameapp/ui/widgets/frame_extended_image.dart';
import 'package:frameapp/ui/widgets/frame_text_field.dart';
import 'package:sp_utilities/utilities.dart';

class ViewPostDialoq extends StatefulWidget {
  
  const ViewPostDialoq({super.key,});

  @override
  State<ViewPostDialoq> createState() => _ViewPostDialoqState();
}

class _ViewPostDialoqState extends State<ViewPostDialoq> {
  final PostCubit _postCubit = sl<PostCubit>();
  late final TextEditingController _noteController;

  bool isCommunityPost = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: _postCubit.state.mainPostState.selectedPost?.note ?? '');
    isCommunityPost = _postCubit.state.mainPostState.selectedPost?.isCommunityPost ?? false;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Post on: ${StringHelpers.printFirebaseTimeStamp(_postCubit.state.mainPostState.selectedPost?.createdAt)}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.black)),
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.black),
        elevation: 0,
      ),
      body: BlocConsumer(
        bloc: _postCubit,
        listener: (context, state) {
          if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.mainPostState.message ?? 'An error occurred', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is UpdatingPost) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Updating...', style: TextStyle(color: Colors.white)),
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
                content: Text('Your Post has been Updated', style: TextStyle(color: Colors.black)),
                backgroundColor: AppColors.limeGreen,
              ),
            );
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          final postState = state as PostState;
          if (postState.mainPostState.selectedPost == null) {
            return Center(
              child: Text('No post selected', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.black)),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_postCubit.state.mainPostState.selectedPost?.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: FrameExtendedimage(
                        url: _postCubit.state.mainPostState.selectedPost?.imageUrl,
                        fit: BoxFit.cover,
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
                  Text(
                    _postCubit.state.mainPostState.selectedPost?.prompt?.promptText ?? 'No Prompt',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.black),
                    textAlign: TextAlign.center,
                  ),
                  Divider(color: Colors.grey, height: 40.0),
                  FrameTextField(
                    controller: _noteController,
                    maxLines: 2,
                    label: 'Your Caption',
                    isLight: true,
                  ),
                  const SizedBox(height: 16.0),
                  Divider(color: Colors.grey[300]!, height: 32.0),
                  Text(
                    'Do you want to post this to the community?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black),
                  ),
                  SizedBox(height: 10.0),
                  FrameButton(
                    type: ButtonType.secondary,
                    label: isCommunityPost ? 'Posted to Community' : 'Post to Community',
                    icon: isCommunityPost ? Icon(Icons.check, color: AppColors.framePurple, semanticLabel: 'Posted') : Icon(Icons.close, color: AppColors.slateGrey, semanticLabel: 'Not Posted'),
                    onPressed: () {
                      setState(() {
                        isCommunityPost = !isCommunityPost;
                      });
                    },
                  ),
                  Divider(color: Colors.grey[300]!, height: 32.0),
                  Row(
                    children: [
                      Expanded(
                        child: FrameButton(
                          type: ButtonType.outline,
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          label: 'Close',
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: FrameButton(
                          type: ButtonType.primary,
                          onPressed: () {
                            PostModel updatedPost = _postCubit.state.mainPostState.selectedPost!.copyWith(
                              note: _noteController.text.isEmpty ? null : _noteController.text,
                              isCommunityPost: isCommunityPost,
                            );
                            _postCubit.updatePost(updatedPost);
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
        },
      )
    );
  }
}
