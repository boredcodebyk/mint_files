import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPermissionState extends ChangeNotifier {
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  PermissionStatus get permissionStatus => _permissionStatus;

  Future<void> requestPermission() async {
    _permissionStatus = await Permission.manageExternalStorage.request();
    notifyListeners();
  }

  Future<void> checkPermissionStatus() async {
    _permissionStatus = await Permission.manageExternalStorage.status;
    notifyListeners();
  }
}

class SettingsModel extends ChangeNotifier {
  bool _isHiddenFileShown = false;
  ThemeMode _themeMode = ThemeMode.system;

  bool get isHiddenFileShown => _isHiddenFileShown;
  set isHiddenFileShown(bool value) {
    if (_isHiddenFileShown == value) return;
    _isHiddenFileShown = value;
    notifyListeners();
    save();
  }

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    if (_themeMode == value) return;
    _themeMode = value;
    notifyListeners();
    save();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isHiddenFileShown', _isHiddenFileShown);
    prefs.setString('themeMode', _themeMode.toString());
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isHiddenFileShown = prefs.getBool('isHiddenFileShown') ?? false;
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.toString() == prefs.getString('themeMode'),
      orElse: () => ThemeMode.system,
    );
    notifyListeners();
  }
}
