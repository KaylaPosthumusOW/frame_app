import 'package:frameapp/constants/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frameapp/ui/screens/community_screen.dart';
import 'package:frameapp/ui/screens/gallery_screen.dart';
import 'package:frameapp/ui/screens/home_screen.dart';
import 'package:frameapp/ui/screens/profile/edit_profile_screen.dart';
import 'package:frameapp/ui/screens/profile/profile_screen.dart';
import 'package:frameapp/ui/screens/settings_screen.dart';


abstract class Navigation {
  static Future<T?> pushToReturn<T extends Object?>(BuildContext context, Widget pageBuilder) async {
    T? obj = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => pageBuilder));
    return obj;
  }

  static Route<RouteSettings> generateRoute(RouteSettings settings) {
    Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case HOME_SCREEN:
        return _routeEndPoint(const HomeScreen(), settings);
      case GALLERY_SCREEN:
        return _routeEndPoint(const GalleryScreen(), settings);
      case COMMUNITY_SCREEN:
        return _routeEndPoint(const CommunityScreen(), settings);
      case SETTINGS_SCREEN:
        return _routeEndPoint(const SettingsScreen(), settings);
      case PROFILE_SCREEN:
        return _routeEndPoint(const ProfileScreen(), settings);
      case EDIT_PROFILE_SCREEN:
        return _routeEndPoint(const EditProfileScreen(), settings);

      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<RouteSettings> _routeEndPoint(Widget builder, RouteSettings settings, {bool fullScreenDialog = false}) {
    return CupertinoPageRoute(
      settings: settings,
      fullscreenDialog: fullScreenDialog,
      builder: (_) => builder,
    );
  }

  static Route<RouteSettings> _errorRoute(route) {
    return CupertinoPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Route Error'),
          ),
          body: Center(
            child: Text("This path doesn't exist, please check the 'Navigation' class for available routes. The route is: $route"),
          ),
        );
      },
    );
  }
}
