import 'package:flutter/material.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/models/post_model.dart';

class CommunityPostCard extends StatefulWidget {
  final PostModel? post;
  const CommunityPostCard({super.key, this.post});

  @override
  State<CommunityPostCard> createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.post?.imageUrl != null)
              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    widget.post!.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 530,
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
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: widget.post?.owner?.profilePicture != null
                        ? NetworkImage(widget.post!.owner!.profilePicture!)
                        : const AssetImage('assets/pngs/blank_profile_image.png') as ImageProvider,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    '${widget.post?.owner?.name} ${widget.post?.owner?.surname}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
