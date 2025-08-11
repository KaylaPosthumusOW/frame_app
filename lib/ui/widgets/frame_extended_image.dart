import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frameapp/constants/themes.dart';

class FrameExtendedimage extends StatefulWidget {
  final String? url;
  final BoxFit fit;
  const FrameExtendedimage({
    super.key,
    this.url,
    this.fit = BoxFit.cover,
  });

  @override
  State<FrameExtendedimage> createState() => _FrameExtendedimageState();
}

class _FrameExtendedimageState extends State<FrameExtendedimage> {

  _loadingImage() {
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

  _content() {
    if (widget.url != null && widget.url!.isNotEmpty && (widget.url!.startsWith('http') || widget.url!.startsWith('https'))) {
      try {
        return CachedNetworkImage(
          key: Key(widget.url!),
          imageUrl: widget.url ?? '',
          errorWidget: (context, url, error) {
            return _loadingImage();
          },
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return Opacity(
              opacity: downloadProgress.progress ?? 0.01,
              child: Center(child: _loadingImage()),
            );
          },
          fit: widget.fit,
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 100),
          fadeInCurve: Curves.easeInOut,
          fadeOutCurve: Curves.easeInOut,
          scale: 5 / 4,
        );
      } catch (e) {
        return _loadingImage();
      }
    } else {
      return _loadingImage();
    }
  }
  @override
  Widget build(BuildContext context) {
    return _content();
  }
}
