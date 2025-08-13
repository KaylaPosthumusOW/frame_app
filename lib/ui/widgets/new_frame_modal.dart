import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/community_posts/community_posts_cubit.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/cubits/prompt/prompt_cubit.dart';
import 'package:frameapp/models/community_post_model.dart';
import 'package:frameapp/models/post_model.dart';
import 'dart:io';

import 'package:frameapp/ui/widgets/frame_button.dart';
import 'package:frameapp/ui/widgets/frame_text_field.dart';

class NewFrameModal extends StatefulWidget {
  final PlatformFile? capturedImage;
  final VoidCallback? onRetake;

  const NewFrameModal({
    super.key,
    this.capturedImage,
    this.onRetake,
  });

  @override
  State<NewFrameModal> createState() => _NewFrameModalState();
}

class _NewFrameModalState extends State<NewFrameModal> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final PostCubit _postCubit = sl<PostCubit>();
  final PromptCubit _promptCubit = sl<PromptCubit>();
  final CommunityPostsCubit _communityPostsCubit = sl<CommunityPostsCubit>();

  bool isCommunityPost = false;

  final TextEditingController _notesController = TextEditingController();
  bool _isUploading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveImageAndCreatePost() async {
    if (widget.capturedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final user = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;
      if (user?.uid == null) {
        throw Exception('User not authenticated');
      }

      final userId = user!.uid!;
      String? downloadUrl;

      if (widget.capturedImage!.path != null) {
        final file = File(widget.capturedImage!.path!);
        final fileName = 'post_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storageRef = FirebaseStorage.instance.ref().child('posts').child(userId).child(fileName);

        final uploadTask = storageRef.putFile(file);
        final snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      }

      if (downloadUrl == null) {
        throw Exception('Failed to upload image to Firebase Storage');
      }

      await _postCubit.createNewPost(
        PostModel(
          owner: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile,
          imageUrl: downloadUrl,
          note: _notesController.text,
          createdAt: Timestamp.now(),
          isCommunityPost: isCommunityPost,
          prompt: _promptCubit.state.mainPromptState.currentPrompt,
        ),
      );

      Navigator.pop(context, {'saved': true, 'notes': _notesController.text});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save image: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Widget _buildImageDisplay() {
    if (widget.capturedImage != null) {
      if (widget.capturedImage!.path != null) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Image.file(
                File(widget.capturedImage!.path!),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 15,
              right: 15,
              child: FrameButton(
                label: 'Retake',
                type: ButtonType.whiteOutline,
                icon: Icon(Icons.replay, color: AppColors.white),
                onPressed: widget.onRetake,
              ),
            ),
          ],
        );
      }
    }

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Image.asset(
        'assets/pngs/image_2.png',
        fit: BoxFit.cover,
        height: 250,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40.0),
            Text(
              'Your New Frame',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 20.0),
            _buildImageDisplay(),
            SizedBox(height: 10.0),
            Text(
              'Do you want to add any notes?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 5.0),
            FrameTextField(
              controller: _notesController,
              maxLines: 3,
              label: 'Add Your Notes Here',
              isLight: true,
            ),
            SizedBox(height: 15.0),
            Text(
              'Do you want to post this to the community?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.black),
            ),
            SizedBox(height: 10.0),
            FrameButton(
              type: ButtonType.secondary,
              label: 'Post to Community',
              icon: isCommunityPost ? Icon(Icons.check, color: AppColors.black) : Icon(Icons.close, color: AppColors.black),
              onPressed: () {
                setState(() {
                  isCommunityPost = !isCommunityPost;
                });
              },
            ),
            SizedBox(height: 10.0),
            Row(
              spacing: 10.0,
              children: [
                Expanded(
                  child: FrameButton(
                    type: ButtonType.outline,
                    label: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: FrameButton(
                    type: ButtonType.primary,
                    label: _isUploading ? 'Uploading...' : 'Save Image',
                    onPressed: _isUploading
                        ? null
                        : () {
                            _saveImageAndCreatePost();
                          },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
