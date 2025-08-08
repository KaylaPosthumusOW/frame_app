import 'package:flutter/material.dart';
import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/ui/widgets/frame_navigation.dart';
import 'package:frameapp/ui/widgets/new_frame_modal.dart';
import 'package:intl/intl.dart';

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

  final AppUserProfileCubit _appUserProfileCubit = sl<AppUserProfileCubit>();

  final PageController _pageController = PageController();
  DateTime _selectedDate = DateTime.now();
  int _currentPage = 1000;
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
              '"Find something red that tells a story."',
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
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return NewFrameModal();
                    }
                );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 20.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${_appUserProfileCubit.state.mainAppUserProfileState.appUserProfile?.name ?? 'Name'}',
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
            SizedBox(height: 10.0),
            Text('Month: ${DateFormat('MMMM yyyy').format(_selectedDate)}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
            _buildDateScroller(),
            SizedBox(height: 10.0),
            _buildFrameGalleries(),
          ],
        )
      ),
      bottomNavigationBar: FrameNavigation(),
    );
  }
}
