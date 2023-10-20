import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task0/auth_screens/signup_screen.dart';
import 'package:task0/widgets/credential_input_field.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainScreenProvider(),
      child: MainScreenContent(),
    );
  }
}

class MainScreenContent extends StatefulWidget {
  const MainScreenContent({Key? key}) : super(key: key);

  @override
  _MainScreenContentState createState() => _MainScreenContentState();
}

class _MainScreenContentState extends State<MainScreenContent> {
  final _formKey = GlobalKey<FormState>();
  late MainScreenProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MainScreenProvider>(context, listen: false);
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    await provider.initializePrefs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Main Screen'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 'logout',
                  child: Text("Log Out"),
                )
              ];
            },
            onSelected: (value) {
              if (value == 'logout') {
                provider.logOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                      (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<MainScreenProvider>(
                builder: (context, provider, child) {
                  provider.nameController.text = provider.prefs.getString('name') ?? '';
                  return CredentialInputField(
                    keyboardType: TextInputType.text,
                    enabled: provider.isEditable,
                    hintText: 'Enter your name',
                    prefixIcon: const Icon(Icons.person),
                    controller: provider.nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                    inputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                  );
                },
              ),
              SizedBox(height: 20),
              Consumer<MainScreenProvider>(
                builder: (context, provider, child) {
                  provider.emailController.text = provider.prefs.getString('email') ?? '';
                  return CredentialInputField(
                    keyboardType: TextInputType.emailAddress,
                    enabled: provider.isEditable,
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.mail),
                    controller: provider.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    inputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                  );
                },
              ),
              SizedBox(height: 20),
              Consumer<MainScreenProvider>(
                builder: (context, provider, child) {
                  provider.passwordController.text = provider.prefs.getString('password') ?? '';
                  return CredentialInputField(
                    keyboardType: TextInputType.visiblePassword,
                    enabled: provider.isEditable,
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock),
                    controller: provider.passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }

                      if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      }
                      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(value)) {
                        return 'Password must contain at least one letter and one number';
                      }
                      return null;
                    },
                    inputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                  );
                },
              ),
              SizedBox(height: 20),
              Consumer<MainScreenProvider>(
                builder: (context, provider, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            provider.setIsEditable(true);
                          });
                        },
                        child: const Text('Edit Profile'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await provider.updatedData();
                            provider.setIsEditable(false);
                          }
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreenProvider with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;
  bool isEditable = false;

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('name') ?? '';
    emailController.text = prefs.getString('email') ?? '';
    passwordController.text = prefs.getString('password') ?? '';
  }

  Future<void> updatedData() async {
    await prefs.setString('name', nameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);
  }

  Future<void> logOut() async {
    await prefs.setBool('isLoggedIn', false);
  }

  void setIsEditable(bool value) {
    isEditable = value;
    notifyListeners();
  }
}