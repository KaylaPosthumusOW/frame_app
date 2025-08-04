import 'package:frameapp/constants/constants.dart';
import 'package:frameapp/cubits/app_user_profile/app_user_profile_cubit.dart';
import 'package:frameapp/cubits/general/general_cubit.dart';
import 'package:sp_firebase/sp_firebase.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:sp_utilities/utilities.dart';

class DependencyInjection {
  static Future<void> init() async {
    await _packages();
    await _repos();
    await _cubits();
    await _main();
  }

  static Future<void> _main() async {
    if (!sl.isRegistered<TPClient>()) sl.registerLazySingleton<TPClient>(() => TPClient());
  }

  static Future<void> _repos() async {}

  static Future<void> _cubits() async {
    sl.registerLazySingleton<AppUserProfileCubit>(() => AppUserProfileCubit());
    sl.registerLazySingleton<GeneralCubit>(() => GeneralCubit());
  }

  static Future<void> _packages() async {
    await UserRepoInitialiser.initialiseDI();
    await SPUtilitiesInitialiser.initialiseDI();
    // await SPFirebaseInitialiser.initialiseDI(options: DefaultFirebaseOptions.currentPlatform, name: '[DEFAULT]');
  }
}
