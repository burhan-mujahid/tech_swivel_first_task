import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task0/widgets/credential_input_field.dart';

import '../user_screens/main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey=GlobalKey<FormState>();

  Future<void> _saveData(String name, String email, String password, bool isLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CredentialInputField(
                keyboardType: TextInputType.text,
                hintText: 'Name',
                prefixIcon: Icon(Icons.person),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
                inputFormatter: FilteringTextInputFormatter.singleLineFormatter,
              ),
              SizedBox(
                height: 20,
              ),
              CredentialInputField(
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }, inputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                  ),
              SizedBox(
                height: 20,
              ),
              CredentialInputField(
                keyboardType: TextInputType.text,
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock),
                controller: passwordController,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }

                  if (value.length<8){
                    return "Password must be at least 8 characters long";
                  }
                  if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(value)) {
                    return 'Password must contain at least one letter and one number';
                  }
                  return null;

                },
                inputFormatter: FilteringTextInputFormatter.singleLineFormatter,

              ),
              SizedBox(
                height: 30,
              ),

              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()){
                      await _saveData(nameController.text, emailController.text, passwordController.text, true);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MainScreen()),
                              (Route<dynamic> route) => false);
                    }
                  },
                  child: Text("Sign Up")
              )



            ],
          ),
        ),
      ),
    );
  }
}
