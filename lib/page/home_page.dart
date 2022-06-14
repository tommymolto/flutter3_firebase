import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kweedo/helpers/notification_helper.dart';
import 'package:kweedo/page/settings_page.dart';
import 'package:kweedo/page/user_page.dart';
import 'package:kweedo/widget/list_users_widget.dart';

class TempHomePage extends StatelessWidget {
  const TempHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'HomePage');

    final user = FirebaseAuth.instance.currentUser!;

    return const Padding(
        padding: EdgeInsets.all(32),
        child: ListUsersWidget(),


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
  final _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void initState() {
    // TODO: implement initState
    _initConfig();
    _remoteConfig.addListener(() {
      setState(() {
        print('oi');
      });
    });

    super.initState();
  }
  Future<void> _initConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(
          seconds: 1), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: const Duration(
          seconds:
          10), // fetch parameters will be cached for a maximum of 1 hour
    ));

    _fetchConfig();
  }

  // Fetching, caching, and activating remote config
  void _fetchConfig() async {
    await _remoteConfig.fetchAndActivate();
    print('settings= ${ _remoteConfig.getBool('settings')}');
  }
  @override
  Widget build(BuildContext context) {
    print('settings= ${ _remoteConfig.getBool('settings')}');
    return Scaffold(
      appBar: AppBar(
        title: Text(_remoteConfig.getString('titulo').isNotEmpty
            ? _remoteConfig.getString('titulo')
            : 'Home'),
        actions: [
          /*IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ));
            },
          ),*/
          IconButton(
            icon: const Icon(Icons.replay_circle_filled),
            onPressed: () {
              FirebaseRemoteConfig.instance.fetchAndActivate();

            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserPage(),
              ));
            },
          ),
          _remoteConfig.getBool('settings') == true ? IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ));
            },
          ): const SizedBox(height: 0,),
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
  }

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