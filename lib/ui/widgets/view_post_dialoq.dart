import 'package:flutter/material.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/models/post_model.dart';
import 'package:frameapp/ui/widgets/frame_button.dart';
import 'package:frameapp/ui/widgets/frame_extended_image.dart';
import 'package:frameapp/ui/widgets/frame_text_field.dart';

class ViewPostDialoq extends StatefulWidget {
  final PostModel post;
  
  const ViewPostDialoq({super.key, required this.post});

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
    _noteController = TextEditingController(text: widget.post.note ?? '');
    bool isCommunityPost = widget.post.isCommunityPost ?? false;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40.0),
            if (widget.post.prompt?.promptText != null)
              Container(
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: AppColors.framePurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: AppColors.framePurple.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prompt:',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.framePurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      widget.post.prompt!.promptText!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black),
                    ),
                  ],
                ),
              ),
      
            if (widget.post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: FrameExtendedimage(
                  url: widget.post.imageUrl,
                  fit: BoxFit.fitWidth,
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
              isLight: true,
            ),
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
            const SizedBox(height: 16.0),
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
                      PostModel updatedPost = widget.post.copyWith(
                        note: _noteController.text.isEmpty ? null : _noteController.text,
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
}
