import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/ui/widgets/frame_navigation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:frameapp/ui/widgets/post_card.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final PostCubit _postCubit = sl<PostCubit>();

  @override
  initState() {
    super.initState();
    _postCubit.loadAllPosts(ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'Your Gallery',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        bloc: _postCubit,
        builder: (context, state) {
          if (state is LoadingPosts) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.framePurple),
            );
          }

          if (state.mainPostState.posts != null && state.mainPostState.posts!.isNotEmpty) {
            return MasonryGridView.count(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              itemCount: state.mainPostState.posts!.length,
              itemBuilder: (context, index) {
                final post = state.mainPostState.posts![index];
                return PostCard(
                  post: post,
                  onTap: () {
                    _postCubit.setSelectedPost(post);
                  },
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
                  'No posts yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Create your first frame to see it here!',
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
