import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kweedo/page/user_page.dart';
import 'package:kweedo/widget/list_users_widget.dart';

class TempHomePage extends StatelessWidget {
  const TempHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'HomePage');

    final user = FirebaseAuth.instance.currentUser!;

    return Padding(
        padding: const EdgeInsets.all(32),
        child: ListUsersWidget(),
      /*Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Conectado por ',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              user.email ?? user.displayName!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.arrow_back, size: 32),
              label: const Text(
                'Sair',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),

          ],
        ),*/

    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: TextField(controller: controller),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserPage(),
            ));
          },
        ),
      ],
    ),
    /*floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserPage(),
        ));
      },
    ),*/
    body: const TempHomePage(),
  );

  Future createUser({required String name}) async {
    /// Reference to document
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final json = {
      'id': docUser.id,
      'name': name,
      'age': 21,
      'birthday': DateTime(2001, 7, 28),
    };
    await FirebaseAnalytics.instance.logEvent(
      name: "create_user",
      parameters: {
        "content_type": "user",
        "name": name,
      },
    );
    /// Create document and write data to Firebase
    await docUser.set(json);
  }
}