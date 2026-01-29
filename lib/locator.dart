import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adptydemo/service_and_managers/adapty_manager.dart';
import 'package:adptydemo/service_and_managers/note_db_service.dart';
import 'package:adptydemo/service_and_managers/note_manager.dart';
import 'package:adptydemo/service_and_managers/user_profile_manager.dart';
import 'package:get_it/get_it.dart';

/// Service locator instance.
final GetIt locator = GetIt.instance;

/// Sets up the service locator with necessary services.
void setupLocator() {
  locator
    ..registerLazySingleton<AdaptyManager>(
      () => AdaptyManager(adapty: Adapty()),
    )
    ..registerLazySingleton<NoteDBService>(NoteDBService.new)
    ..registerLazySingleton<UserProfileManager>(UserProfileManager.new)
    ..registerLazySingleton<NoteManager>(NoteManager.new);
}
