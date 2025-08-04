import 'package:flutter/material.dart';
import 'package:frameapp/ui/widgets/frame_navigation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:frameapp/ui/widgets/image_card.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
            'Your Gallery',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
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
