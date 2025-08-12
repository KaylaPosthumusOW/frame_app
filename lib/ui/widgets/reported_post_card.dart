import 'package:flutter/material.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/models/post_model.dart';
import 'package:frameapp/ui/widgets/view_post_dialoq.dart';
class ReportedPostCard extends StatefulWidget {
  final PostModel? post;
  final Function? onTap;
  const ReportedPostCard({super.key, this.post, this.onTap});

  @override
  State<ReportedPostCard> createState() => _ReportedPostCardState();
}

class _ReportedPostCardState extends State<ReportedPostCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.post != null ? () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ViewPostDialoq(post: widget.post!),
        );
      } : null,
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
                Stack(
                    children: [
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
                    ]
                )
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
                    child: Icon(Icons.image, size: 40, color: Colors.grey[500],),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightPink,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.close, color: AppColors.white, size: 28,),
                      )
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.limeGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.check, color: AppColors.white, size: 28,),
                      )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}