import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taskifypro/common/widgets/Appbar.dart';
import 'package:taskifypro/src/Authentication/presentation/Loginpage.dart';
import 'package:taskifypro/src/CreateNewTask/CreateNewTask.dart';
import 'package:taskifypro/src/YourTasks/YourTasks.dart';
import 'package:taskifypro/src/profile/profile.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
            child: Lottie.asset('assets/animations/TaskAnimation.json')),
        // title: const Text(
        //   'Taskify',
        //   style: TextStyle(
        //     color: Colors.teal,
        //     fontSize: 25,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        actions: [
          // const Text('LogOut'),
          IconButton(
            icon: const Icon(Icons.person),
            color: Colors.teal,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
        ],
      ),

      body: const YourTasks(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Colors.teal.shade200,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNewTask(),
            ),
          );
        },
      ),
    );
  }
}
