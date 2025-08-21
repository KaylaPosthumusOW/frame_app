import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/ui/widgets/frame_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  PageController? _pageController;
  double _currentPage = 0;
  List<String> images = [
    'assets/svg/onboarding_image_studying.svg',
    'assets/svg/onboarding_image_selfie.svg',
    'assets/svg/onboarding_image_sharing.svg',
  ];
  List<String> title = [
    'Feeling Stuck?',
    'Rediscover your creativity',
    'Share Your Moments',
  ];
  List<String> bodyText = [
    'Spending all day behind your computer can drain your creativity. Let’s change that.',
    'Frame gives you daily prompts to spark new ideas and help you create again.',
    'Share your moments with friends and family, and discover new content from the community.',
  ];

  bool _imagesPrecached = false;

  Future<void> animateScroll(int page) async {
    await _pageController!.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  Widget _indicatorAndButtonsWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSmoothIndicator(
          activeIndex: _currentPage.toInt(),
          count: images.length,
          effect: ExpandingDotsEffect(activeDotColor: AppColors.framePurple, dotWidth: 12, dotHeight: 12),
        ),
        SizedBox(height: 8),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Visibility(
                    visible: _currentPage > 0, // <-- only show back if not on first page
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: TextButton(
                      child: Row(
                        children: [
                          Text(
                            'Back',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .titleLarge
                                ?.copyWith(color: AppColors.slateGrey),
                          ),
                        ],
                      ),
                      onPressed: () {
                        animateScroll(_currentPage.toInt() - 1);
                      },
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Visibility(
                    visible: _currentPage.toInt() != 2,
                    child: TextButton(
                      child: Row(
                        children: [
                          Text(
                            'Next',
                            style: Theme.of(context).primaryTextTheme.titleLarge
                                ?.copyWith(color: AppColors.framePurple),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: AppColors.framePurple, size: 20),
                        ],
                      ),
                      onPressed: () {
                        animateScroll(_currentPage.toInt() + 1);
                      },
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _populateScreen(int page) {
    Widget pageContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          images[page],
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.4,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 20),
        Text(
          title[page],
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          bodyText[page],
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        if (page == 2)
          FrameButton(
            type: ButtonType.primary,
            label: 'Get Started',
            onPressed: () async {
              final profile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile;
              if (profile != null) {
                await _appUserProfileCubit.setHasSeenOnboarding();
              }
            },
          ),
      ],
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(image: AssetImage(images[page]), fit: BoxFit.cover),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white.withValues(alpha: 0.6),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: pageContent,
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      for (String imagePath in images) {
        precacheImage(AssetImage(imagePath), context);
      }
      _imagesPrecached = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            children: [
              _populateScreen(0),
              _populateScreen(1),
              _populateScreen(2),
            ],
            onPageChanged: (index) {
              setState(() => _currentPage = index.toDouble());
            },
          ),
          Positioned(bottom: 50, left: 0, right: 0, child: _indicatorAndButtonsWidget()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
