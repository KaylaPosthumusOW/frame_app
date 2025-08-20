import 'package:flutter/material.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/models/post_model.dart';
import 'package:frameapp/ui/widgets/frame_button.dart';
import 'package:frameapp/ui/widgets/view_post_dialoq.dart';

class ReportedPostCard extends StatefulWidget {
  final PostModel? post;
  final Function? onTap;
  const ReportedPostCard({super.key, this.post, this.onTap});

  @override
  State<ReportedPostCard> createState() => _ReportedPostCardState();
}

class _ReportedPostCardState extends State<ReportedPostCard> {

  final PostCubit _postCubit = sl<PostCubit>();

  Widget _approveReportedPost() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Approve Post', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.black)),
            const SizedBox(height: 20),
            Text('Are you sure you want to approve this post?', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FrameButton(
                    type: ButtonType.outline,
                    label: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FrameButton(
                    type: ButtonType.primary,
                    label: 'Approve',
                    onPressed: () {
                      PostModel updatedPost = widget.post!.copyWith(
                        isArchived: false,
                        isReported: false,
                      );
                      _postCubit.updatePost(updatedPost);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _removeReportedPost() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Remove Post', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.black)),
            const SizedBox(height: 20),
            Text('Are you sure you want to remove this post?', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.black)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FrameButton(
                    type: ButtonType.outline,
                    label: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FrameButton(
                    type: ButtonType.primary,
                    label: 'Remove',
                    onPressed: () {
                      PostModel updatedPost = widget.post!.copyWith(
                        isArchived: true,
                      );
                      _postCubit.updatePost(updatedPost);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.post?.imageUrl != null)
                Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.post!.imageUrl!,
                      fit: BoxFit.fitWidth,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.grey[300],
                            child: CircularProgressIndicator(color: AppColors.framePurple),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            color: AppColors.white,
                            child: const Icon(Icons.broken_image),
                          ),
                        );
                      },
                    ),
                  ),
                ])
              else
                AspectRatio(
                  aspectRatio: 2 / 2,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.limeGreen,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.check, color: AppColors.black),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => _approveReportedPost(),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.lightPink,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.report_problem_outlined, color: AppColors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => _removeReportedPost(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
