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
      onTap: widget.post != null
          ? () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ViewPostDialoq(post: widget.post!),
        );
      }
          : null,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: widget.post?.imageUrl != null
              ? Image.network(
            widget.post!.imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey[300],
                  child: CircularProgressIndicator(
                    color: AppColors.framePurple,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              );
            },
          )
              : AspectRatio(
            aspectRatio: 1,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.image,
                size: 50,
                color: Colors.grey[500],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
