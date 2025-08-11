import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/prompt/prompt_cubit.dart';
import 'package:frameapp/models/app_user_profile.dart';
import 'package:frameapp/ui/widgets/frame_navigation.dart';
import 'package:frameapp/ui/widgets/new_frame_modal.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    _promptCubit.loadCurrentPrompt();
  }

  final PageController _pageController = PageController();
  DateTime _selectedDate = DateTime.now();
  int _currentPage = 1000;
  String? _downloadUrl;
  List<DateItem> _generateWeek(DateTime date) {
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (index) {
      DateTime currentDay = startOfWeek.add(Duration(days: index));
      return DateItem(
        date: currentDay,
        isSelected: currentDay.day == _selectedDate.day &&
            currentDay.month == _selectedDate.month &&
            currentDay.year == _selectedDate.year,
        hasContent: currentDay.day % 2 != 0,
      );
    });
  }
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      DateTime newDate = DateTime.now().add(Duration(days: (index - 1000) * 7));
      _selectedDate = newDate;
    });
  }

  Widget _dailyFrameContainer() {
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
  }

  Widget _buildDateScroller() {
    return SizedBox(
      height: 90,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          DateTime dateForWeek = DateTime.now().add(Duration(days: (index - 1000) * 7));
          List<DateItem> weekDates = _generateWeek(dateForWeek);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDates.map((dateItem) {
              return _buildDateCard(dateItem);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildDateCard(DateItem dateItem) {
    bool isSelected = dateItem.isSelected;
    bool hasContent = dateItem.hasContent;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = dateItem.date;
        });
      },
      child: Container(
        width: 48,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.framePurple : AppColors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.framePurple : AppColors.white.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 8),
                Text(
                  DateFormat('EEE').format(dateItem.date),
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                Text(
                  DateFormat('dd').format(dateItem.date),
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (hasContent)
              Positioned(
                top: 8,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC792FF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrameGalleries() {
    return SizedBox(
      height: 380,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(35),
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
                  const Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 100,
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
        },
      ),
    );
  }

  Widget _takenPictureDisplay() {
    return BlocConsumer<SPFileUploaderCubit, SPFileUploaderState>(
        bloc: _imageUploaderCubit,
        listener: (context, state) {
          if (state is SPFileUploaderAllUploadTaskCompleted) {
            _downloadUrl = state.mainSPFileUploadState.downloadUrls?.first;
            if (_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile != null) {
              final AppUserProfile appUserProfile = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.copyWith(profilePicture: _downloadUrl);
              _appUserProfileCubit.updateProfile(appUserProfile);
            }
            setState(() {});
          }

          if (state is SPFileUploaderErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.mainSPFileUploadState.errorMessage ?? state.mainSPFileUploadState.message ?? 'Upload failed'),
            ));
          }
        },
        builder: (context, state) {
          if (state.mainSPFileUploadState.uploadTasks != null && state.mainSPFileUploadState.uploadTasks!.isNotEmpty) {
            return Container(
              width: 200,
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: CircularProgressIndicator(color: AppColors.white),
            );
          }

          if (state is ProfileLoading) {
            return Container(
              width: 200,
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: CircularProgressIndicator(color: AppColors.white),
            );
          }

          if (_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.profilePicture != null && _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.profilePicture!.isNotEmpty && _downloadUrl == null) {
            final String? profileUrl = _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.profilePicture != null ? _appUserProfileCubit.state.mainAppUserProfileState.appUserProfile!.profilePicture : null;

            return Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                profileUrl != null
                    ? SizedBox(
                  width: 200,
                  height: 200,
                  child: ClipRRect(borderRadius: BorderRadius.circular(100), child: Image.network(profileUrl, fit: BoxFit.cover)),
                )
                    : Container(),
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.framePurple,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white, size: 30),
                      onPressed: () {
                        _addProfilePhoto();
                      },
                    ),
                  ),
                )
              ],
            );
          } else if (_downloadUrl != null) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(_downloadUrl!),
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.framePurple,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white, size: 30),
                      onPressed: () {
                        _addProfilePhoto();
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 120, color: Colors.white),
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.framePurple,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white, size: 30),
                      onPressed: () {
                        _addProfilePhoto();
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        });
  }

  void _addProfilePhoto() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Photo Source'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _takePictureFromCamera();
                  },
                  child: Text('Camera'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _takePictureFromGallery();
                  },
                  child: Text('Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _takePictureFromCamera() {
    _imageUploaderCubit.singleSelectImageFromCameraToUploadToReference(
      storageRef: null,
      skipUploadToFirebase: true,
    );
  }

  void _takePictureFromGallery() {
    _imageUploaderCubit.singleSelectImageFromGalleryToUploadToReference(
      storageRef: null,
      skipUploadToFirebase: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SPFileUploaderCubit, SPFileUploaderState>(
      bloc: _imageUploaderCubit,
      listener: (context, state) {
        print('SPFileUploaderCubit state change: ${state.runtimeType}');
        
        if (state is SPFileUploaderAllUploadTaskCompleted) {
          if (state.mainSPFileUploadState.files != null && state.mainSPFileUploadState.files!.isNotEmpty) {
            print('Image captured successfully, showing modal');
            final capturedFile = state.mainSPFileUploadState.files!.first;
            
            // Show modal with captured image
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
            ).then((result) {
              if (result != null && result['saved'] == true) {
                print('Frame saved with notes: ${result['notes']}');
                // Handle saved frame here
              }
            });
          }
        }
        
        if (state is SPFileUploaderErrorState) {
          print('Error occurred: ${state.mainSPFileUploadState.errorMessage}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.mainSPFileUploadState.errorMessage ?? 'Upload failed'),
            ),
          );
        }
      },
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actionsPadding: const EdgeInsets.only(right: 20.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.name ?? 'User'}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              'Streak: 0 days 🔥',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
            // _takenPictureDisplay(),
            SizedBox(height: 10.0),
            Text('Month: ${DateFormat('MMMM yyyy').format(_selectedDate)}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
            _buildDateScroller(),
            SizedBox(height: 10.0),
            _buildFrameGalleries(),
          ],
        )
      ),
      bottomNavigationBar: FrameNavigation(),
    ),
    );
  }
}
