import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class YourTasks extends StatefulWidget {
//   const YourTasks({super.key});

//   @override
//   State<YourTasks> createState() => _YourTasksState();
// }

// class _YourTasksState extends State<YourTasks> {
//   FirebaseAuth auth = FirebaseAuth.instance;

//   Future<void> _deleteTask(String taskId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(auth.currentUser!.uid)
//           .collection('Tasks')
//           .doc(taskId)
//           .delete();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Task deleted successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete task: $e')),
//       );
//     }
//   }

//   Future<void> _completeTask(String taskId) async {
//     try {
//       var taskRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(auth.currentUser!.uid)
//           .collection('Tasks')
//           .doc(taskId);

//       var task = await taskRef.get();

//       // Check if task is not already completed
//       if (task.exists && !(task.data()!['isCompleted'] ?? false)) {
//         await taskRef.update({'isCompleted': true});

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Task marked as completed')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to complete task: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Tasks'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(auth.currentUser!.uid)
//             .collection('Tasks')
//             .orderBy('created_at', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No tasks available'));
//           }

//           var tasks = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: tasks.length,
//             itemBuilder: (context, index) {
//               var task = tasks[index].data() as Map<String, dynamic>;
//               var taskId = tasks[index].id; // Get the document ID
//               var isCompleted =
//                   task['isCompleted'] ?? false; // Provide default value if null

//               return Card(
//                 margin: EdgeInsets.all(10),
//                 elevation: 5,
//                 child: Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             task['title'],
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               decoration: isCompleted
//                                   ? TextDecoration.lineThrough
//                                   : TextDecoration.none,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.check, color: Colors.green),
//                                 onPressed: isCompleted
//                                     ? null
//                                     : () => _completeTask(taskId),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () => _deleteTask(taskId),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Description: ${task['description']}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Due Date: ${task['due_date'].toDate()}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Due Time: ${task['due_time']}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Estimate Time: ${task['estimate_time']}',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       if (isCompleted)
//                         Text(
//                           'Status: Completed',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class YourTasks extends StatefulWidget {
  const YourTasks({Key? key}) : super(key: key);

  @override
  State<YourTasks> createState() => _YourTasksState();
}

class _YourTasksState extends State<YourTasks> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> _completedTasks = [];

  Future<void> _deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('Tasks')
          .doc(taskId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $e')),
      );
    }
  }

  Future<void> _completeTask(String taskId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('Tasks')
          .doc(taskId)
          .update({'isCompleted': true});

      setState(() {
        _completedTasks.add(taskId); // Add completed task ID
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task marked as completed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete task: $e')),
      );
    }
  }

  Future<void> _uncompleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('Tasks')
          .doc(taskId)
          .update({'isCompleted': false});

      setState(() {
        _completedTasks.remove(taskId); // Remove task ID from completed list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task marked as uncompleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to uncomplete task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('Tasks')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No tasks available'));
          }

          var tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index].data() as Map<String, dynamic>;
              var taskId = tasks[index].id; // Get the document ID
              var isCompleted = _completedTasks.contains(taskId);

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            task['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          Row(
                            children: [
                              if (!isCompleted)
                                IconButton(
                                  icon: const Icon(Icons.check,
                                      color: Colors.green),
                                  onPressed: () => _completeTask(taskId),
                                ),
                              if (isCompleted)
                                IconButton(
                                  icon: const Icon(Icons.undo,
                                      color: Colors.blue),
                                  onPressed: () => _uncompleteTask(taskId),
                                ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTask(taskId),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Description: ${task['description']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Due Date: ${task['due_date'].toDate()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Due Time: ${task['due_time']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Estimate Time: ${task['estimate_time']} hr',
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (isCompleted)
                        const Text(
                          'Status: Completed',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
