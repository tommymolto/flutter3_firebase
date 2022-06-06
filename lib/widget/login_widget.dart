import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginWidget  extends StatefulWidget {
  const LoginWidget({ Key? key }) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget > {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40,),
        TextField(
          controller: emailController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Email',

          ),
        ),
        const SizedBox(height: 4,),
        TextField(
          controller: passwordController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'Password',

          ),
          obscureText: true,
        ),
        const SizedBox(height: 20,),
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50)
            ),

            onPressed: (){}, icon: Icon(Icons.lock_open, size: 32,), label: Text('Entrar', style: TextStyle(fontSize: 24),))

      ],
    ),
  );
}