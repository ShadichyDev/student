
// import 'package:student/core/databases/server.dart';
import 'package:student/core/databases/shared_prefs.dart';
import 'package:student/core/default_configs.dart';
// import 'package:student/core/databases/user.dart';
// import 'package:student/misc/misc_functions.dart';

final class AppConfig {
  AppConfig._instance();
  static final _studyPlanInstance = AppConfig._instance();
  factory AppConfig() {
    return _studyPlanInstance;
  }

  Map<String, dynamic> data = {};

  Future<void> initialize() async {
    data = SharedPrefs.getString("config", defaultConfig)!;
  }

  Future<void> _write() async {
    await SharedPrefs.setString("config", data);
  }

  void setConfig(String id, Object? value) {
    data[id] = (value is num ||
            value is bool ||
            value is Iterable ||
            value is String ||
            value == null)
        ? value
        : value.toString();
    _write();
  }

  T? getConfig<T>(String id) {
    switch (T) {
      case const (bool):
        return bool.tryParse("${data[id]}") as T?;
      case const (int):
        return int.tryParse("${data[id]}") as T?;
      case const (double):
        return double.tryParse("${data[id]}") as T?;
      case const (List):
      case const (Iterable):
        return data[id] ?? [];
      default:
        return data[id] as T?;
    }
  }
}

