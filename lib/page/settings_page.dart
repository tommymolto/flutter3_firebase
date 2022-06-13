import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:kweedo/helpers/helpers_auth.dart';

import '../widget/icon_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text( 'Settings')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SettingsGroup(
            title: 'GENERAL',
            children: <Widget>[
              buildNotifications(),
              buildLogout(),
              buildDeleteAccount(),
            ],
          ),
          const SizedBox(height: 32),
          SettingsGroup(
            title: 'FEEDBACK',
            children: <Widget>[
              const SizedBox(height: 8),
              buildReportBug(context),
              buildSendFeedback(context),
            ],
          ),
        ],
      ),
    ),
  );

  Widget buildNotifications() => SimpleSettingsTile(
    title: 'Notifications',
    subtitle: '',
    leading: const Switch(value: false, onChanged: null),
    onTap: () async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
      HelpersAuth.showSnackBar( 'Push Notification OK');
    },
  );
  Widget buildLogout() => SimpleSettingsTile(
    title: 'Logout',
    subtitle: '',
    leading: const IconWidget(icon: Icons.logout, color: Colors.blueAccent),
    onTap: () {
      HelpersAuth.showSnackBar( 'Clicked Logout');
    },
  );

  Widget buildDeleteAccount() => SimpleSettingsTile(
    title: 'Delete Account',
    subtitle: '',
    leading: const IconWidget(icon: Icons.delete, color: Colors.pink),
    onTap: () => HelpersAuth.showSnackBar( 'Clicked Delete Account'),
  );

  Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
    title: 'Report A Bug',
    subtitle: '',
    leading: const IconWidget(icon: Icons.bug_report, color: Colors.teal),
    onTap: () => HelpersAuth.showSnackBar('Clicked Report A Bug'),
  );

  Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
    title: 'Send Feedback',
    subtitle: '',
    leading: const IconWidget(icon: Icons.thumb_up, color: Colors.purple),
    onTap: () => HelpersAuth.showSnackBar( 'Clicked SendFeedback'),
  );
}