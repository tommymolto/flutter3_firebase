import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kweedo/page/home_page.dart';
import 'package:kweedo/widget/login_widget.dart';
import 'animation/fade_animation.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static const String title = '01- Firebase Auth';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
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
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Algo deu errado!'));
        } else if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginWidget();
        }
      },
    ),
  );
}
