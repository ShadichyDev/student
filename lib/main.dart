import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/core/databases/hive.dart';
import 'package:student/ui/connect.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await Storage().register();
  // await SharedPrefs.initialize();
  // await AppConfig().initialize();
  // if (Storage().fetch<bool>("theme.systemTheme") == true) {
  if (Storage().fetch<bool>("theme.systemTheme") == true) {
    await SystemTheme.accentColor.load();
  }
  // await NotificationService().initialize();
  runApp(const StudentApp());
}
