import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'main.dart';
import 'task.dart';
import 'task_details_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    setState(() {
      tasks = fetchTasks();
    });
  }

  Future<void> _deleteTask(String objectId) async {
    final taskToDelete = ParseObject('Task')..objectId = objectId;
    await taskToDelete.delete().then((response) {
      if (response.success) {
        _refreshTasks(); // Refresh the list after deletion
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
      margin: EdgeInsets.only(bottom: 8.0, top: 4.0, right: 4.0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Tasks',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder<List<Task>>(
          future: tasks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var task = snapshot.data![index];
                  return Card(
                    elevation: 2.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      title: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          _statusLabel(task.status),
                          Padding(
                            padding: EdgeInsets.only(top: 35.0),
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => TaskDetailsScreen(task: task),
                          ),
                        )
                            .then((value) {
                          // Check if the task was deleted
                          if (value == true) {
                            _refreshTasks();
                          }
                        });
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditTaskScreen(task: task),
                                    ),
                                  )
                                  .then((_) => _refreshTasks());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Delete Task'),
                                    content: Text(
                                        'Are you sure you want to delete this task?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                          _deleteTask(
                                              task.objectId); // Delete the task
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No tasks found'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddTaskScreen()))
                .then((_) =>
                    _refreshTasks()); // Refresh tasks after AddTaskScreen is popped
          },
          child: Icon(Icons.add),
          tooltip: 'Add Task',
        ));
  }
}
