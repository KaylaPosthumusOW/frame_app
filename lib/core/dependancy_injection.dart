import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/community_posts/community_posts_cubit.dart';
import 'package:frameapp/cubits/general/general_cubit.dart';
import 'package:frameapp/cubits/post/post_cubit.dart';
import 'package:frameapp/cubits/prompt/prompt_cubit.dart';
import 'package:frameapp/firebase_options.dart';
import 'package:frameapp/stores/firebase/app_user_profile_firebase_repository.dart';
import 'package:frameapp/stores/firebase/community_post_firebase_repository.dart';
import 'package:frameapp/stores/firebase/main_firebase_repository.dart';
import 'package:frameapp/stores/firebase/post_firebase_repository.dart';
import 'package:frameapp/stores/firebase/prompt_firebase_repository.dart';
import 'package:sp_firebase/sp_firebase.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:sp_utilities/utilities.dart';

class DependencyInjection {
  static init() async {
    await _packages();
    await _repos();
    await _cubits();
    await _main();
  }

  static _main() async {}

  static _repos() async {
    sl.registerLazySingleton<MainFirebaseRepository>(() => MainFirebaseRepository());
    sl.registerLazySingleton<AppUserProfileFirebaseRepository>(() => AppUserProfileFirebaseRepository());
    sl.registerLazySingleton<PromptFirebaseRepository>(() => PromptFirebaseRepository());
    sl.registerLazySingleton<PostFirebaseRepository>(() => PostFirebaseRepository());
    sl.registerLazySingleton<CommunityPostFirebaseRepository>(() => CommunityPostFirebaseRepository());
  }

  static _cubits() async {
    sl.registerSingleton<AppUserProfileCubit>(AppUserProfileCubit());
    sl.registerLazySingleton<GeneralCubit>(() => GeneralCubit()..checkIfLatestAppVersion());
    sl.registerSingleton<PromptCubit>(PromptCubit());
    sl.registerSingleton<PostCubit>(PostCubit());
    sl.registerSingleton<CommunityPostsCubit>(CommunityPostsCubit());
  }

  static _packages() async {
    await SPFirebaseInitialiser.initialiseDI(name: '[DEFAULT]', options: DefaultFirebaseOptions.currentPlatform);
    await UserRepoInitialiser.initialiseDI();
    await SPUtilitiesInitialiser.initialiseDI();
  }
}
