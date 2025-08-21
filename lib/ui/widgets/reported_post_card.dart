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
                      _postCubit.approveReportedPost(widget.post!);
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
                      _postCubit.archiveReportedPost(widget.post!);
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
        elevation: 4,
        shadowColor: Colors.grey.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.post?.imageUrl != null
                    ? Image.network(
                  widget.post!.imageUrl!,
                  width: 120,
                  height: 160,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 120,
                      height: 160,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(color: AppColors.framePurple),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 160,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 40),
                    );
                  },
                )
                    : Container(
                  width: 120,
                  height: 160,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reason for Reporting',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.post?.isReportedReason ?? 'No reason provided',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.limeGreen,
                              foregroundColor: AppColors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => _approveReportedPost(),
                              );
                            },
                            child: const Icon(Icons.check, size: 22),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightPink,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => _removeReportedPost(),
                              );
                            },
                            child: const Icon(Icons.report_problem_outlined, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
