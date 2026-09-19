import 'package:p/features/settings/domain/repositories/settings_repository.dart';

class LogoutUseCase {
  final SettingsRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
