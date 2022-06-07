import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../main.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/user.dart';

class UserPage extends StatefulWidget {
  final User? user;

   UserPage({Key? key, this.user}) : super(key: key) {
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'UserPage');

  }

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController controllerName;
  late TextEditingController controllerAge;
  late TextEditingController controllerDate;
  String avatarController = '';
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  void initState() {
    super.initState();

    controllerName = TextEditingController();
    controllerAge = TextEditingController();
    controllerDate = TextEditingController();
    if (widget.user != null) {
      final user = widget.user!;

      controllerName.text = user.name;
      controllerAge.text = user.age.toString();
      controllerDate.text = DateFormat('yyyy-MM-dd').format(user.birthday);
      avatarController = user.avatar ?? '';
    }
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerAge.dispose();
    controllerDate.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'UserPageState');

    final isEditing = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? controllerName.text : 'Add User'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteUser(widget.user!);
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    'Deleted ${controllerName.text} to Firebase!',
                    style: const TextStyle(fontSize: 24),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: controllerName,
              decoration: decoration('Nome'),
              validator: (text) =>
                  text != null && text.isEmpty ? 'Nome invalido' : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: controllerAge,
              decoration: decoration('Idade'),
              keyboardType: TextInputType.number,
              validator: (text) => text != null && int.tryParse(text) == null
                  ? 'Dados invalidos'
                  : null,
            ),
            const SizedBox(height: 24),
            DateTimeField(
              controller: controllerDate,
              decoration: decoration('Aniversario'),
              validator: (dateTime) =>
                  dateTime == null ? 'Dados invalidos' : null,
              initialValue: controllerDate.text.isNotEmpty ? DateTime.parse(controllerDate.text) : null,
              format: DateFormat('yyyy-MM-dd'),
              onShowPicker: (context, currentValue) => showDatePicker(
                context: context,
                firstDate: DateTime(1920),
                lastDate: DateTime(2100),
                initialDate: currentValue ?? DateTime.now(),
              ),
            ),
            const SizedBox(height: 32),

            const SizedBox(height: 32),
            avatarController.isNotEmpty ? GestureDetector(
              child: SizedBox(height: 24,
                  child: Image.network(
                     avatarController,
                    // width: double.infinity,
                    fit: BoxFit.fitHeight,
                  )),
              onTap: selectFile,
            ) : ElevatedButton(
              child: const Text('Select File'),
              onPressed:selectFile,
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              child: Text(isEditing ? 'Save' : 'Create'),
              onPressed: () {
                final isValid = formKey.currentState!.validate();

                if (isValid) {
                  print('avatar: $avatarController');
                  final user = User(
                      id: widget.user?.id ?? '',
                      name: controllerName.text,
                      age: int.parse(controllerAge.text),
                      birthday: DateTime.parse(controllerDate.text),
                      avatar: avatarController);

                  if (isEditing) {
                    updateUser(user);
                  } else {
                    createUser(user);
                  }
                  final action = isEditing ? 'Atualizado' : 'Criado';
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      ' ${controllerName.text} $action!',
                      style: const TextStyle(fontSize: 24),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );

  Widget buildMediaPreview() {
    final file = File(pickedFile!.path!);

    switch (pickedFile!.extension!.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':

      /* case 'mp4':
        return VideoPlayerWidget(file: file);*/
      default:
        return Center(child: Text(pickedFile!.name));
    }
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(height: 50);
        }
      });

  Future createUser(User user) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'create_user'
    );
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }

  Future updateUser(User user) async {
    await FirebaseAnalytics.instance.logEvent(
        name: 'update_user'
    );
    final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);

    final json = user.toJson();
    await docUser.update(json);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;


    setState(() {
      pickedFile = result.files.first;
    });
    await uploadFile();
  }

  Future deleteUser(User user) async {
    await FirebaseAnalytics.instance.logEvent(
        name: 'delete_user',
      parameters: {
        'firebase_screen': 'delete_user',
        'firebase_screen_class': 'none',
      }
    );
    /// Reference to document
    final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);

    await docUser.delete();
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    //print('Download Link: $urlDownload');
    setState(() {
      avatarController = urlDownload;

      uploadTask = null;
    });
  }
}
