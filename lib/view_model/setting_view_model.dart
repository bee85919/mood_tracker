import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/model/setting_model.dart';
import 'package:mood_tracker/repo/setting_repository.dart';

class SettingViewModel extends Notifier<SettingModel> {
  final SettingRepository _repository;

  SettingViewModel(this._repository);

  void setDarkMode(bool value) {
    _repository.setDarkMode(value);
    state = SettingModel(darkMode: value);
  }

  @override
  SettingModel build() {
    return SettingModel(darkMode: _repository.isDarkMode());
  }
}

final settingProvider = NotifierProvider<SettingViewModel, SettingModel>(
  () => throw UnimplementedError(),
);
