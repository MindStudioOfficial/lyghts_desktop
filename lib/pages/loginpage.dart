import 'package:flutter/material.dart';
import 'package:lyghts_desktop/config.dart';
import 'package:lyghts_desktop/models.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginPage({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? usernameController, passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController?.dispose();
    passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            appTitle,
            style: defaultTextStyle.copyWith(fontSize: 80),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: usernameController,
              decoration: defaultTextFieldDecoration.copyWith(
                hintText: "Username",
              ),
              cursorColor: defaultTextFieldCursorColor,
              style: textFieldStyle,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: passwordController,
              decoration: defaultTextFieldDecoration.copyWith(
                hintText: "Password",
              ),
              cursorColor: defaultTextFieldCursorColor,
              style: textFieldStyle,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextButton(
            onPressed: () {
              widget.onLoginSuccess();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Login",
                style: defaultTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
