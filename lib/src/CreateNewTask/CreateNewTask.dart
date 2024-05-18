import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:taskifypro/common/widgets/Appbar.dart';
import 'package:taskifypro/common/widgets/ElevetedButton.dart';
import 'package:taskifypro/common/widgets/Textformfield.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CreateNewTask extends StatefulWidget {
  const CreateNewTask({super.key});

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final _formKey = GlobalKey<FormState>();
  // form key
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _DescriptionController = TextEditingController();
  bool _isLoading = false;

  // Creating date and time variables
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  Duration _duration = Duration(hours: 1);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void _scheduleNotification(
      String taskId, String title, String description, DateTime dueDate) async {
    final scheduledDate = dueDate.subtract(Duration(minutes: 15));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      taskId.hashCode,
      title,
      description,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          // 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  void _showDatepicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(), // You can adjust this to fit your needs
      lastDate: DateTime(2025),
    );

    if (pickedDate != null && pickedDate != _date) {
      setState(() {
        _date = pickedDate;
      });
    }
  }

  void _showTimePicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (pickedTime != null && pickedTime != _time) {
      setState(() {
        _time = pickedTime;
      });
    }
  }

  Future<void> _saveTask() async {
    setState(() {
      _isLoading = true;
    });

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String description = _DescriptionController.text;
      DateTime dueDate = _date;
      TimeOfDay dueTime = _time;
      Duration estimateTime = _duration;

      try {
        String taskId = DateTime.now().millisecondsSinceEpoch.toString();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('Tasks')
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set({
          'title': title,
          'description': description,
          'due_date': dueDate,
          'due_time': '${dueTime.hour}:${dueTime.minute}',
          'estimate_time':
              '${estimateTime.inHours}:${estimateTime.inMinutes % 60}',
          'created_at': Timestamp.now(),
          'isCompleted': false, // Initialize isCompleted to false
        });

        // Schedule the notification
        _scheduleNotification(taskId, title, description, dueDate);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Task created successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to create task: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // List of predefined durations
    List<Duration> durations = const [
      Duration(minutes: 30),
      Duration(hours: 1),
      Duration(hours: 2),
      Duration(hours: 3),
      Duration(hours: 4),
      Duration(hours: 5),
      Duration(hours: 6),
      Duration(hours: 10),
      Duration(hours: 12),
      Duration(hours: 15),
      Duration(hours: 20),
      Duration(hours: 24),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NEW TASK',
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                    height: 150,
                    child:
                        Lottie.asset('assets/animations/TaskAnimation.json')),
                CustomTextFormFiled(
                  controller: _titleController,
                  labelText: 'What is to be done?',
                  prefixIcon: Icons.task,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Title';
                    }
                    return null;
                  },
                  enabled: true,
                  keyboardType: TextInputType.streetAddress,
                  obscureText: false,
                  onChanged: (String value) {},
                  maxline: 1,
                ),
                const SizedBox(height: 20),
                CustomTextFormFiled(
                  controller: _DescriptionController,
                  labelText: 'Describe your task',
                  prefixIcon: Icons.description,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please give a description';
                    }
                    return null;
                  },
                  enabled: true,
                  keyboardType: TextInputType.streetAddress,
                  obscureText: false,
                  onChanged: (String value) {},
                  maxline: 5,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Due Date:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _showDatepicker,
                      child: Text('${_date.day}/${_date.month}/${_date.year}'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Due Time:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _showTimePicker,
                      child: Text('${_time.format(context)}'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Estimate Time:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 20),
                    DropdownButton<Duration>(
                      value: _duration,
                      onChanged: (Duration? newValue) {
                        setState(() {
                          _duration = newValue!;
                        });
                      },
                      items: durations
                          .map<DropdownMenuItem<Duration>>((Duration value) {
                        return DropdownMenuItem<Duration>(
                          value: value,
                          child: Text(
                              '${value.inHours}h ${value.inMinutes % 60}m'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // CustomElevetedButton(
                //   buttonText: 'Create a task',
                //   buttonHeight: 50,
                //   buttonWidth: 250,
                //   buttontextSize: 20,
                //   backgroundColor: Colors.blueAccent.shade200,
                //   // backgroundColor: const Color(0xFF1CB5B0),
                //   textColor: Colors.white,
                //   elevation: 4,
                //   borderRadius: 15,
                //   onPressed: () {
                //     if (_formKey.currentState!.validate()) {
                //       _saveTask();
                //     }
                //   },
                // ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _saveTask();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(250, 50),
                    textStyle: TextStyle(fontSize: 20),
                    primary: Colors.teal,
                    onPrimary: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('Create a task'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
