import 'package:flutter/material.dart';
import 'package:frameapp/ui/widgets/frame_navigation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:frameapp/ui/widgets/image_card.dart';


class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Center(
        child: MasonryGridView.count(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          crossAxisCount: 2,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
          itemCount: 2,
          itemBuilder: (context, index) {
            return ImageCard();
          },
        ),
      ),
      bottomNavigationBar: FrameNavigation(),
    );
  }
}
