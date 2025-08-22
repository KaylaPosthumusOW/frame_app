import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:sp_utilities/utilities.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final PostCubit _postCubit = sl<PostCubit>();

  @override
  void initState() {
    super.initState();
    _postCubit.loadUsersReportedPosts(ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        iconTheme: IconThemeData(color: AppColors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reported Posts',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 4),
            Text(
              'You can still see this post, but it has been temporarily removed from the community while it is being reviewed.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _displayReportedPostsForUser(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayReportedPostsForUser() {
    return BlocBuilder<PostCubit, PostState>(
      bloc: _postCubit,
      builder: (context, state) {
        if (state is LoadingReportedPostsForUser) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PostError) {
          return Center(
            child: Text(
              'Error: ${state.mainPostState.errorMessage}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.mainPostState.reportedPostsForUser != null) {
          return ListView.builder(
            itemCount: state.mainPostState.reportedPostsForUser!.length,
            itemBuilder: (context, index) {
              final post = state.mainPostState.reportedPostsForUser![index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 160,
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: post.imageUrl != null
                                  ? Image.network(
                                post.imageUrl!,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 160,
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
                                  : const Icon(Icons.image, size: 40, color: Colors.grey),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'REPORTED',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '⚠ Your post is under review',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Created on: ${StringHelpers.printFirebaseTimeStamp(post.createdAt)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 20),

                            if (post.isReportedReason != null)
                              Text(
                                'Why it was reported?',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                              ),
                              Text(
                                '${post.isReportedReason}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
                              ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return Center(
          child: Text(
            'No notifications yet.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          ),
        );
      },
    );
  }
}
