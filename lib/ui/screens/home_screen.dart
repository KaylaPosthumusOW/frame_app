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

class DateItem {
  final DateTime date;
  final bool isSelected;
  final bool hasContent;

  DateItem({
    required this.date,
    this.isSelected = false,
    this.hasContent = false,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PromptCubit _promptCubit = sl<PromptCubit>();
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();
  final SPFileUploaderCubit _imageUploaderCubit = sl<SPFileUploaderCubit>();
  final PostCubit _postCubit = sl<PostCubit>();

  @override
  void initState() {
    super.initState();
    _promptCubit.loadCurrentPrompt();
    _postCubit.loadTodaysFrame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appUserProfileCubit.updateStreak();
      _showOnboardingIfNeeded(context);
    });
  }

  void _showOnboardingIfNeeded(BuildContext context) async {
    final profile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;
    if (profile != null && profile.hasSeenOnboarding != true) {
      await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'Onboarding',
        pageBuilder: (context, animation, secondaryAnimation) {
          return _OnboardingPage(
            onFinish: () async {
              await _appUserProfileCubit.setHasSeenOnboarding();
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  Widget _dailyFrameContainer() {
    return BlocBuilder<PromptCubit, PromptState>(
      bloc: _promptCubit,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(top: 20.0, bottom: 25.0, left: 20.0, right: 20.0),
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
              SizedBox(height: 10.0),
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
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.framePurple,
            ),
          );
        }

        if (state is PostError) {
          return Center(
            child: Text('Error: ${state.mainPostState.errorMessage}', style: TextStyle(color: Colors.red)),
          );
        }

        if (state.mainPostState.todaysFrame == null) {
          return Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            height: 500,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: () {
                _takePictureFromCamera();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Today`s Frame',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 15),
                        Text(
                          '"${_promptCubit.state.mainPromptState.currentPrompt?.promptText ?? ''}"',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.lightPink),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 8),
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
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.limeGreen,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.mainPostState.todaysFrame != null) {
          final todaysFrame = state.mainPostState.todaysFrame;
          return Container(
            width: double.infinity,
            height: 500,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(todaysFrame?.imageUrl ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  void _takePictureFromCamera() {
    _imageUploaderCubit.singleSelectImageFromCameraToUploadToReference(
      storageRef: null,
      skipUploadToFirebase: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SPFileUploaderCubit, SPFileUploaderState>(
      bloc: _imageUploaderCubit,
      listener: (context, state) {
        if (state is CreatedPost) {
          if (state.mainSPFileUploadState.files != null && state.mainSPFileUploadState.files!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Post created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }

        if (state is SPFileUploaderAllUploadTaskCompleted) {
          if (state.mainSPFileUploadState.files != null && state.mainSPFileUploadState.files!.isNotEmpty) {
            final capturedFile = state.mainSPFileUploadState.files!.first;

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: NewFrameModal(
                  capturedImage: capturedFile,
                  onRetake: () {
                    _takePictureFromCamera();
                  },
                ),
              ),
            );
          }
        }

        if (state is SPFileUploaderErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.mainSPFileUploadState.errorMessage ?? 'Upload failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
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
                  SizedBox(height: 4),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.person_outline_rounded, color: Colors.black54, size: 40),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 15.0),
                _dailyFrameContainer(),
                SizedBox(height: 20.0),
                _buildTodaysFrame(),
              ],
            )),
        bottomNavigationBar: FrameNavigation(),
      ),
    );
  }
}

class _OnboardingPage extends StatefulWidget {
  final VoidCallback onFinish;
  const _OnboardingPage({required this.onFinish});

  @override
  State<_OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<_OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Welcome to Frame!',
      'desc': 'Capture and share your daily moments.'
    },
    {
      'title': 'Track Your Streak',
      'desc': 'Stay active and keep your streak going.'
    },
    {
      'title': 'Join the Community',
      'desc': 'See how others interpret today’s prompt.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 250,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(data['title'] ?? '', style: Theme.of(context).textTheme.headlineLarge),
                        SizedBox(height: 16),
                        Text(data['desc'] ?? '', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (i) => Container(
                    width: 10,
                    height: 10,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == i ? AppColors.framePurple : Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _currentPage == onboardingData.length - 1
                    ? widget.onFinish
                    : () => _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
                child: Text(_currentPage == onboardingData.length - 1 ? 'Get Started' : 'Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
