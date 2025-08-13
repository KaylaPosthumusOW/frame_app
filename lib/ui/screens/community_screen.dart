import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/cubits/prompt/prompt_cubit.dart';
import 'package:frameapp/ui/widgets/community_post_card.dart';
import 'package:frameapp/ui/widgets/frame_navigation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:frameapp/ui/widgets/image_card.dart';
import 'package:frameapp/ui/widgets/post_card.dart';
import 'package:frameapp/ui/widgets/view_post_dialoq.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final PostCubit _postCubit = sl<PostCubit>();

  @override
  initState() {
    super.initState();
    _postCubit.loadCommunityPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From the Community',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              'See how others interpreted today’s prompt.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
        body: BlocBuilder<PostCubit, PostState>(
          bloc: _postCubit,
          builder: (context, state) {
            if (state is LoadingCommunityPosts) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.framePurple),
              );
            }

            if (state.mainPostState.communityPosts != null && state.mainPostState.communityPosts!.isNotEmpty) {
              return MasonryGridView.count(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                crossAxisCount: 2,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                itemCount: state.mainPostState.communityPosts!.length,
                itemBuilder: (context, index) {
                  final post = state.mainPostState.communityPosts![index];
                  return GestureDetector(
                    onTap: () {
                      _postCubit.setSelectedPost(post);
                      Navigator.pushNamed(context, '/community/view_post');
                    },
                    child: CommunityPostCard(post: post),
                  );
                },
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No community posts yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your first frame to the community to see it here!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
      bottomNavigationBar: FrameNavigation(),
      );
  }
}
