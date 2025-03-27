import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
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
                    decoration: InputDecoration(labelText: 'Title'),
                    onSaved: (value) => _title = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a title' : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    onSaved: (value) => _description = value ?? '',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a description' : null,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveTask,
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _createTaskInBack4App(_title, _description);
    }
  }

  Future<void> _createTaskInBack4App(String title, String description) async {
    final task = ParseObject('Task')
      ..set('title', title)
      ..set('description', description);
    await task.save();
    Navigator.of(context).pop(); // Go back to the previous screen
  }
}
