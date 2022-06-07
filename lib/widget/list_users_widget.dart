import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';
import '../page/user_page.dart';

class ListUsersWidget extends StatefulWidget {
  @override
  _ListUsersWidgetState createState() => _ListUsersWidgetState();
}

class _ListUsersWidgetState extends State<ListUsersWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Usuarios'),
    ),
    body: buildUsers(),
    // body: buildSingleUser(),

  );

  Widget buildUsers() => StreamBuilder<List<User>>(
      stream: readUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          final users = snapshot.data!;

          return ListView(
            children: users.map(buildUser).toList(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      });

  Widget buildSingleUser() => FutureBuilder<User?>(
    future: readUser(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Something went wrong! ${snapshot.error}');
      } else if (snapshot.hasData) {
        final user = snapshot.data;

        return user == null
            ? const Center(child: Text('No User'))
            : buildUser(user);
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );

  Widget buildUser(User user) => ListTile(
    leading: CircleAvatar(child: Text('${user.age}')),
    title: Text(user.name),
    subtitle: Text(user.birthday.toIso8601String()),
  );

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  Future<User?> readUser() async {
    /// Get single document by ID
    final docUser = FirebaseFirestore.instance.collection('users').doc('my-id');
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return User.fromJson(snapshot.data()!);
    }
  }


}