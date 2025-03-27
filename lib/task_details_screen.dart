import 'package:flutter/material.dart';
import 'task.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'edit_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  TaskDetailsScreen({required this.task});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late Task task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  void updateTask(Task updatedTask) {
    setState(() {
      task = updatedTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _statusLabel(task.status), // Status label
                SizedBox(height: 8),
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text('Edit'),
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => EditTaskScreen(task: task),
                          ),
                        )
                            .then((updatedTask) {
                          if (updatedTask != null) {
                            updateTask(updatedTask);
                          }
                        });
                      },
                    ),
                    ElevatedButton(
                      child: Text('Delete'),
                      onPressed: () => _deleteTask(context, task.objectId),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteTask(BuildContext context, String objectId) async {
    final taskToDelete = ParseObject('Task')..objectId = objectId;
    await taskToDelete.delete().then((response) {
      if (response.success) {
        Navigator.of(context).pop(true); // Go back after deletion
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting task')),
        );
      }
    });
  }

  Widget _statusLabel(bool status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: status ? Colors.lightGreen : Colors.redAccent[100],
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        status ? 'Done' : 'In Progress',
        style: TextStyle(
          color: status ? Colors.green[900] : Colors.red[900],
          fontSize: 12.0,
        ),
      ),
    );
  }
}
