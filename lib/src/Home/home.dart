import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskifypro/common/widgets/Appbar.dart';
import 'package:taskifypro/src/Authentication/presentation/Loginpage.dart';
import 'package:taskifypro/src/CreateNewTask/CreateNewTask.dart';
import 'package:taskifypro/src/YourTasks/YourTasks.dart';

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
        title: const Text('Taskify'),
        actions: [
          const Text('LogOut'),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      // appBar: CustomAppBar(
      //   title: 'Taskify',
      // ),
      body: const YourTasks(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
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

    // return DefaultTabController(
    //     length: 3,
    //     child: Scaffold(
    //       appBar: AppBar(
    //         backgroundColor: Colors.teal,
    //         bottom: TabBar(
    //           tabs: [
    //             Tab(
    //               icon: Icon(Icons.home, color: Colors.white),
    //             ),
    //             Tab(
    //               icon: Icon(Icons.add, color: Colors.white),
    //             ),
    //             Tab(
    //               icon: Icon(Icons.done_all_outlined, color: Colors.white),
    //             ),
    //           ],
    //         ),
    //         title: Align(
    //           alignment: Alignment.centerLeft,
    //           child: Text(
    //             'Taskify',
    //             style: const TextStyle(
    //               color: Colors.white,
    //               fontSize: 25,
    //               letterSpacing: 2,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ),
    //       ),
    //       body: TabBarView(children: [
    //         YourTasks(),
    //         CreateNewTask(),
    //         CompletedTask(),
    //       ]),
    //     ));
  }
}
