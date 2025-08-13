import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/ui/widgets/reported_post_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ReportedPostsManagement extends StatefulWidget {
  const ReportedPostsManagement({super.key});

  @override
  State<ReportedPostsManagement> createState() => _ReportedPostsManagementState();
}

class _ReportedPostsManagementState extends State<ReportedPostsManagement> {
  final PostCubit _postCubit = sl<PostCubit>();

  @override
  void initState() {
    super.initState();
    _postCubit.loadReportedPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reported Posts'),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        bloc: _postCubit,
        builder: (context, state) {
          if (state is LoadingReportedPosts) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.framePurple),
            );
          }

          if (state is LoadedReportedPosts && state.mainPostState.reportedPosts != null && state.mainPostState.reportedPosts!.isNotEmpty) {
            return MasonryGridView.count(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              itemCount: state.mainPostState.reportedPosts!.length,
              itemBuilder: (context, index) {
                final post = state.mainPostState.reportedPosts![index];
                return ReportedPostCard(
                  post: post,
                );
              },
            );
          }

          return const Center(
            child: Text('No reported posts found.'),
          );
        },
      ),
    );
  }
}
