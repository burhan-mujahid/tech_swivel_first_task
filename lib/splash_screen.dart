import "dart:async";

import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:task0/auth_screens/signup_screen.dart";
import "package:task0/user_screens/main_screen.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late bool isLoggedIn;


  @override
  void initState(){
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });

    Timer(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> isLoggedIn ? MainScreen() : SignUpScreen()),
              (Route<dynamic> route) => false);
    });

  }

  // void navigateToMainScreen(){
  //   Timer(Duration(seconds: 3),(){
  //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> SignUpScreen()),
  //             (Route<dynamic> route) => false);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(size: 200,),
      ),
    );

  }
}
