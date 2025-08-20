import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/cubits/prompt/prompt_cubit.dart';
import 'package:frameapp/ui/widgets/frame_navigation.dart';
import 'package:frameapp/ui/widgets/new_frame_modal.dart';
import 'package:sp_utilities/utilities.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFrameUpload = false;
  final PromptCubit _promptCubit = sl<PromptCubit>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final SPFileUploaderCubit _imageUploaderCubit = sl<SPFileUploaderCubit>();
  final PostCubit _postCubit = sl<PostCubit>();

  @override
  void initState() {
    super.initState();
    _promptCubit.loadCurrentPrompt();
    _postCubit.loadTodaysFrame(
      ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '',
    );
  }

  Widget _dailyFrameContainer() {
    return BlocBuilder<PromptCubit, PromptState>(
      bloc: _promptCubit,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.lightPink,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today´s Frame',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Text(
                  '"${_promptCubit.state.mainPromptState.currentPrompt?.promptText ?? ''}"',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTodaysFrame() {
    return BlocBuilder<PostCubit, PostState>(
      bloc: _postCubit,
      builder: (context, state) {
        if (state is LoadingTodaysFrame) {
          return Center(child: CircularProgressIndicator(color: AppColors.framePurple));
        }

        if (state is PostError) {
          return Center(
            child: Text(
              'Error: ${state.mainPostState.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.mainPostState.todaysFrame == null) {
          return GestureDetector(
            onTap: _takePictureFromCamera,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        'Today`s Frame',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '"${_promptCubit.state.mainPromptState.currentPrompt?.promptText ?? ''}"',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.lightPink),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  _captureButton(),
                ],
              ),
            ),
          );
        }

        if (state.mainPostState.todaysFrame!.imageUrl != null) {
          return GestureDetector(
            onTap: _takePictureFromCamera,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        'Today`s Frame',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '"${_promptCubit.state.mainPromptState.currentPrompt?.promptText ?? ''}"',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.lightPink),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  _captureButton(),
                ],
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          height: 500,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No frame captured today',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 20),
              _captureButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _captureButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Capture Frame',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          CircleAvatar(
            backgroundColor: AppColors.limeGreen,
            child: Icon(Icons.arrow_forward, color: Colors.black),
          ),
        ],
      ),
    );
  }

  /// --- Take picture using uploader cubit
  void _takePictureFromCamera() {
    _isFrameUpload = true;
    _imageUploaderCubit.singleSelectImageFromCameraToUploadToReference(
      storageRef: null,
      skipUploadToFirebase: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// --- Listen for upload events
        BlocListener<SPFileUploaderCubit, SPFileUploaderState>(
          bloc: _imageUploaderCubit,
          listener: (context, state) {
            if (state is SPFileUploaderAllUploadTaskCompleted && _isFrameUpload) {
              if (state.mainSPFileUploadState.files != null &&
                  state.mainSPFileUploadState.files!.isNotEmpty) {
                final capturedFile = state.mainSPFileUploadState.files!.first;

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: NewFrameModal(
                      capturedImage: capturedFile,
                      onRetake: _takePictureFromCamera,
                    ),
                  ),
                );
              }
              _isFrameUpload = false;
            }

            if (state is SPFileUploaderErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.mainSPFileUploadState.errorMessage ?? 'Upload failed')),
              );
            }
          },
        ),

        /// --- Listen for post creation
        BlocListener<PostCubit, PostState>(
          bloc: _postCubit,
          listener: (context, state) {
            if (state is CreatedPost) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post created successfully!'), backgroundColor: Colors.green),
              );
              _postCubit.loadTodaysFrame(
                ownerUid: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.uid ?? '',
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actionsPadding: const EdgeInsets.only(right: 20.0),
          title: BlocBuilder<AppUserProfileCubit, AppUserProfileState>(
            bloc: _appUserProfileCubit,
            builder: (context, state) {
              final streak = state.mainAppUserProfileState.appUserProfile?.activeDays ?? 0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${state.mainAppUserProfileState.appUserProfile?.name ?? 'User'}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Streak: $streak days 🔥',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
                  ),
                ],
              );
            },
          ),
          centerTitle: false,
          actions: [
            CircleAvatar(
              radius: 30,
              backgroundImage: _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.profilePicture != null
                  ? NetworkImage(_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.profilePicture!)
                  : const AssetImage('assets/pngs/blank_profile_image.png') as ImageProvider,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 15.0),
              _dailyFrameContainer(),
              const SizedBox(height: 20.0),
              _buildTodaysFrame(),
            ],
          ),
        ),
        bottomNavigationBar: const FrameNavigation(),
      ),
    );
  }
}
