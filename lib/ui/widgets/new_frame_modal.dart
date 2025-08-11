import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/cubits/prompt/prompt_cubit.dart';
import 'package:frameapp/models/post_model.dart';
import 'package:frameapp/models/prompt_model.dart';
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

  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildImageDisplay() {
    if (widget.capturedImage != null) {
      if (widget.capturedImage!.path != null) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.file(
            File(widget.capturedImage!.path!),
            fit: BoxFit.cover,
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
        color: AppColors.slateGrey,
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
                    label: 'Save Image',
                    onPressed: () {
                      _postCubit.createNewPost(
                        PostModel(
                          owner: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile,
                          imageUrl: widget.capturedImage?.path ?? '',
                          note: _notesController.text,
                          createdAt: Timestamp.now(),
                        ),
                      );

                      _notesController.clear();
                      Navigator.pop(context);
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
