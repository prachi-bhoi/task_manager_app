import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task; // Pass the existing task to the screen

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late bool _status;

  @override
  void initState() {
    super.initState();
    _title = widget.task.title;
    _description = widget.task.description;
    _status = widget.task.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(labelText: 'Title'),
                    onSaved: (value) => _title = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a title' : null,
                  ),
                  TextFormField(
                    initialValue: _description,
                    decoration: InputDecoration(labelText: 'Description'),
                    onSaved: (value) => _description = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a description' : null,
                  ),
                  SwitchListTile(
                    title: Text('Status: ${_status ? "Done" : "In Progress"}'),
                    value: _status,
                    onChanged: (bool value) {
                      setState(() {
                        _status = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: _updateTask,
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final taskToUpdate = ParseObject('Task')
        ..objectId = widget.task.objectId
        ..set('title', _title)
        ..set('description', _description)
        ..set('status', _status);
      ;

      taskToUpdate.save().then((response) {
        if (response.success) {
          // Return the updated task
          Navigator.of(context).pop(Task.fromParse(taskToUpdate));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating task')),
          );
        }
      });
    }
  }
}
