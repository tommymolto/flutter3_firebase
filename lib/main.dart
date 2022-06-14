import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kweedo/helpers/helpers_auth.dart';
import 'package:kweedo/page/auth_page.dart';
import 'package:kweedo/page/home_page.dart';
import 'package:kweedo/page/verify_email_page.dart';
import 'package:kweedo/widget/login_widget.dart';
import 'animation/fade_animation.dart';
import 'firebase_options.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static const String title = 'Firebase Auth';

  @override
  Widget build(BuildContext context) => MaterialApp(
    scaffoldMessengerKey: HelpersAuth.messengerKey,
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
          .copyWith(secondary: Colors.tealAccent),
    ),
    home: MainPage(),
  );
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const VerifyEmailPage();
        } else {
          return AuthPage();
        }
      },
    ),
  );
}