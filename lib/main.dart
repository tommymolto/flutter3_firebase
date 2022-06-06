import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kweedo/widget/login_widget.dart';
import 'animation/fade_animation.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(body: LoginWidget(),);
}


