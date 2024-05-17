import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taskifypro/src/Authentication/presentation/signuppage.dart';
import 'package:taskifypro/src/Home/home.dart';
import 'package:taskifypro/common/widgets/Appbar.dart';
import 'package:taskifypro/common/widgets/ElevetedButton.dart';
import 'package:taskifypro/common/widgets/Textformfield.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  // form key
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Login successful, navigate to home page
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      print("Login error: ${e.message}");
      // Show SnackBar for incorrect login credentials
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect email or password. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CustomAppBar(
      //   title: "Welcome to Taskify!",
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                const Text(
                  "Login to Taskify!",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  "Let’s Start",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    child: Lottie.asset(
                      'assets/animations/LoginAnimation.json',
                    ),
                  ),
                ),
                CustomTextFormFiled(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Email';
                    }
                    return null;
                  },
                  enabled: true,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  onChanged: (String value) {},
                  maxline: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormFiled(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid password';
                    } else {
                      if (value.length < 6) {
                        return 'password length is 6 character minimum';
                      }
                    }
                    return null;
                  },
                  enabled: true,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  onChanged: (String value) {},
                  maxline: 1,
                ),
                const SizedBox(height: 60.0),
                CustomElevetedButton(
                  buttonText: 'Login',
                  buttonHeight: 50,
                  buttonWidth: 150,
                  buttontextSize: 20,
                  backgroundColor: const Color(0xFF1CB5B0),
                  // backgroundColor: const Color(0xFF1CB5B0),
                  textColor: Colors.white,
                  elevation: 4,
                  borderRadius: 15,
                  // onPressed: () => _login(context),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login(context);
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Navigate to SignupScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupScreen(),
                      ),
                    );
                  },
                  child: const Text('Don\'t have an account? Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
