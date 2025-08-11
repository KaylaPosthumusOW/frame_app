import 'package:flutter/material.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/models/post_model.dart';
import 'package:frameapp/ui/widgets/view_post_dialoq.dart';
class PostCard extends StatefulWidget {
  final PostModel? post;
  final Function? onTap;
  const PostCard({super.key, this.post, this.onTap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.post?.prompt?.promptText ?? 'Prompt Text',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold, 
                        color: AppColors.black
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.limeGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward, size: 28),
                  ),
                ],
              ),
              // SizedBox(height: 8),
              // Center(child: Text(StringHelpers.printFirebaseTimeStamp(widget.post?.createdAt), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.slateGrey))),
            ],
          ),
        ),
      ),
    );
  }
}