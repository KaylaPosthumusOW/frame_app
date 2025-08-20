import 'package:frameapp/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:frameapp/ui/screens/admin/prompt_management.dart';
import 'package:frameapp/ui/screens/admin/reported_posts_management.dart';
import 'package:frameapp/ui/screens/community_screen.dart';
import 'package:frameapp/ui/screens/gallery_screen.dart';
import 'package:frameapp/ui/screens/home_screen.dart';
import 'package:frameapp/ui/screens/login/login_screen.dart';
import 'package:frameapp/ui/screens/main_frame_app_screen.dart';
import 'package:frameapp/ui/screens/profile/edit_profile_screen.dart';
import 'package:frameapp/ui/screens/profile/profile_screen.dart';
import 'package:frameapp/ui/screens/register/register_screen.dart';
import 'package:frameapp/ui/screens/settings_screen.dart';
import 'package:frameapp/ui/widgets/community_view_post_dialoq.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: MAIN_SCREEN,
    navigatorKey: rootNavigatorKey,
    routes: <GoRoute>[
      GoRoute(
        path: MAIN_SCREEN,
        name: MAIN_SCREEN,
        builder: (BuildContext context, GoRouterState state) => MainFrameAppScreen(),
      ),
      GoRoute(
        path: HOME_SCREEN,
        name: HOME_SCREEN,
        builder: (BuildContext context, GoRouterState state) => HomeScreen(),
      ),
      GoRoute(
        path: SETTINGS_SCREEN,
        name: SETTINGS_SCREEN,
        builder: (BuildContext context, GoRouterState state) => SettingsScreen(),
      ),
      GoRoute(
        path: GALLERY_SCREEN,
        name: GALLERY_SCREEN,
        builder: (BuildContext context, GoRouterState state) => GalleryScreen(),
      ),
      GoRoute(
        path: COMMUNITY_SCREEN,
        name: COMMUNITY_SCREEN,
        builder: (BuildContext context, GoRouterState state) => CommunityScreen(),
      ),
      GoRoute(
        path: PROFILE_SCREEN,
        name: PROFILE_SCREEN,
        builder: (BuildContext context, GoRouterState state) => ProfileScreen(),
      ),
      GoRoute(
        path: EDIT_PROFILE_SCREEN,
        name: EDIT_PROFILE_SCREEN,
        builder: (BuildContext context, GoRouterState state) => EditProfileScreen(),
      ),
      GoRoute(
        path: COMMUNITY_VIEW_POST,
        name: COMMUNITY_VIEW_POST,
        builder: (BuildContext context, GoRouterState state) => CommunityViewPostDialoq(),
      ),
      GoRoute(
        path: LOGIN_SCREEN,
        name: LOGIN_SCREEN,
        builder: (BuildContext context, GoRouterState state) => LoginScreen(),
      ),
      GoRoute(
        path: REGISTER_SCREEN,
        name: REGISTER_SCREEN,
        builder: (BuildContext context, GoRouterState state) => RegisterScreen(),
      ),
      GoRoute(
        path: PROMPT_MANAGEMENT_SCREEN,
        name: PROMPT_MANAGEMENT_SCREEN,
        builder: (BuildContext context, GoRouterState state) => PromptManagement(),
      ),
      GoRoute(
        path: REPORTED_POSTS_SCREEN,
        name: REPORTED_POSTS_SCREEN,
        builder: (BuildContext context, GoRouterState state) => ReportedPostsManagement(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      return null;
    },
    errorBuilder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Route Error'),
        ),
        body: Center(
          child: Text("This path doesn't exist: ${state.uri.toString()}"),
        ),
      );
    },
  );

  static GoRouter get router => _router;
}
