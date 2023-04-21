import 'package:flutter/foundation.dart';

import 'features/login/widgets/select_admin.dart';
import 'features/login/admin_widgets/user_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart';

import 'features/login/login.dart';
import 'firebase_options.dart';
import 'services/firebase_notification.dart';
import 'services/local_notifications.dart';

const storage = FlutterSecureStorage();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  LocalNotificationService.initialize();
  await FirebaseNotifications.initialize();

  final String? token = await storage.read(key: 'user_access_token');
  final String? userType = await storage.read(key: 'user_type');

  // if (kDebugMode) {
  PluginManager.instance
    ..register(const WidgetInfoInspector())
    ..register(const WidgetDetailInspector())
    ..register(AlignRuler());
  runApp(
    UMEWidget(
      child: MyApp(token: token, userType: userType),
    ),
  );
  // }
  // runApp(MyApp(token: token, userType: userType));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final String? token;
  final String? userType;
  User? user = FirebaseAuth.instance.currentUser;
  MyApp({Key? key, required this.token, required this.userType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (user != null) {
      if (userType == 'user') {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dark Knights App',
          theme: ThemeData.dark(),
          home: SelectAdmin(
            token: token!,
          ),
        );
      } else {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dark Knights App',
          theme: ThemeData.dark(),
          home: const UserList(),
        );
      }
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dark Knights App',
        theme: ThemeData.dark(),
        home: const LoginScreen(),
      );
    }
  }
}
