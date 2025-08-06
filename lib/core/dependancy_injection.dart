import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/general/general_cubit.dart';
import 'package:frameapp/cubits/prompt/prompt_cubit.dart';
import 'package:frameapp/stores/firebase/app_user_profile_firebase_repository.dart';
import 'package:frameapp/stores/firebase/main_firebase_repository.dart';
import 'package:frameapp/firebase_options.dart';
import 'package:frameapp/stores/firebase/prompt_firebase_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:sp_firebase/sp_firebase.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:sp_utilities/utilities.dart';
import 'package:firebase_core/firebase_core.dart';

class DependencyInjection {
  static Future<void> init() async {
    await _packages();
    await _repos();
    await _cubits();
    await _main();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> _main() async {
    if (!sl.isRegistered<TPClient>()) sl.registerLazySingleton<TPClient>(() => TPClient());
  }

  static Future<void> _repos() async {
    GetIt.instance.registerLazySingleton<MainFirebaseRepository>(() => MainFirebaseRepository());
    GetIt.instance.registerLazySingleton<AppUserProfileFirebaseRepository>(() => AppUserProfileFirebaseRepository());
    GetIt.instance.registerLazySingleton<PromptFirebaseRepository>(() => PromptFirebaseRepository());

  }

  static Future<void> _cubits() async {
    sl.registerLazySingleton<AppUserProfileCubit>(() => AppUserProfileCubit());
    sl.registerLazySingleton<GeneralCubit>(() => GeneralCubit());
    sl.registerLazySingleton<PromptCubit>(() => PromptCubit());
  }

  static Future<void> _packages() async {
    await UserRepoInitialiser.initialiseDI();
    await SPUtilitiesInitialiser.initialiseDI();
    // await SPFirebaseInitialiser.initialiseDI(options: DefaultFirebaseOptions.currentPlatform, name: '[DEFAULT]');
  }
}
