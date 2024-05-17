import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taskifypro/common/widgets/ElevetedButton.dart';
import 'package:taskifypro/common/widgets/Textformfield.dart';
import 'package:taskifypro/src/Authentication/presentation/Loginpage.dart';

class SignupScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  // form key
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signup(BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Signup successful, navigate to home page
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      // Handle signup errors
      print("Signup error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // Use a different icon
          color: Colors.teal,
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Taskify!",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Let’s begin the adventure",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 300,
                    child: Lottie.asset('assets/animations/GmailAnimation.json',
                        repeat: false),
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
                SizedBox(height: 40.0),
                CustomElevetedButton(
                  buttonText: 'SignUp',
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
                      _signup(context);
                    }
                  },
                ),
                SizedBox(height: 5.0),
                TextButton(
                  onPressed: () {
                    // Navigate back to LoginScreen
                    Navigator.pop(context);
                  },
                  child: Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
