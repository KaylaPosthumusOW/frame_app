import 'package:frameapp/constants/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frameapp/ui/screens/home_screen.dart';


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
