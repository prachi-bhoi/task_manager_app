import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task {
  String objectId;
  String title;
  String description;
  bool status;

  Task(
      {required this.objectId, required this.title, required this.description, required this.status});

  factory Task.fromParse(ParseObject object) {
    return Task(
      objectId: object.objectId!,
      title: object.get<String>('title') ?? 'No Title',
      description: object.get<String>('description') ?? 'No Description',
      status: object.get<bool>('status') ?? false,
    );
  }
}
