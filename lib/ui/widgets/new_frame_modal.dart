import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/cubits/prompt/prompt_cubit.dart';
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
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('posts')
            .child(userId)
            .child(fileName);

        final uploadTask = storageRef.putFile(file);
        final snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      } else if (widget.capturedImage!.bytes != null) {
        final fileName = 'post_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('posts')
            .child(userId)
            .child(fileName);

        final uploadTask = storageRef.putData(widget.capturedImage!.bytes!);
        final snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      }
      
      if (downloadUrl == null) {
        throw Exception('Failed to upload image to Firebase Storage');
      }

      await _postCubit.createNewPost(
        PostModel(
          owner: user,
          imageUrl: downloadUrl,
          note: _notesController.text,
          createdAt: Timestamp.now(),
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
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.file(
            File(widget.capturedImage!.path!),
            fit: BoxFit.cover,
            height: 280,
          ),
        );
      } else if (widget.capturedImage!.bytes != null) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.memory(
            widget.capturedImage!.bytes!,
            fit: BoxFit.cover,
            height: 250,
          ),
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
          color: AppColors.slateGrey,
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
            Center(
              child: Container(
                width: 60.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            _buildImageDisplay(),
            SizedBox(height: 10.0),
            if (widget.capturedImage != null) ...[
              FrameButton(
                type: ButtonType.primary,
                onPressed: () {
                  Navigator.pop(context);
                  widget.onRetake?.call();
                },
                label: 'Retake Image',
              ),
              SizedBox(height: 10.0),
            ],
            Text(
              'Do you want to add any notes?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.white),
            ),
            SizedBox(height: 5.0),
            FrameTextField(
              controller: _notesController,
              maxLines: 3,
              label: 'Add Your Notes Here',
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
                    onPressed: _isUploading ? null : () {
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
