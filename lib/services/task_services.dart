import 'dart:convert';
import 'package:daily_do/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final String dbUrl =
      'https://daily-do-bef70-default-rtdb.firebaseio.com/tasks';

  /// Fetch all tasks for a user (no auth token required)
  Future<List<TaskModel>> fetchTasks(String userId) async {
    final url = Uri.parse('$dbUrl/$userId.json');
    print('📥 Fetching tasks from: $url');

    final response = await http.get(url);

    if (response.statusCode == 200 && response.body != 'null') {
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded.entries
              .map((e) => TaskModel.fromJson(e.value, e.key))
              .toList();
        }
      } catch (e) {
        print('❌ Error decoding tasks: $e');
      }
    } else {
      print('⚠️ Failed to fetch tasks. Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');
    }

    return [];
  }

  /// Add a task
  Future<String?> addTask(String userId, TaskModel task) async {
    final url = Uri.parse('$dbUrl/$userId.json');
    final body = json.encode(task.toJson());

    print('📤 Adding task to: $url');
    print('📝 Payload: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name'];
    } else {
      print('❌ Failed to add task. Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');
      return null;
    }
  }

  /// Update a task
  Future<void> updateTask(String userId, TaskModel task) async {
    final url = Uri.parse('$dbUrl/$userId/${task.id}.json');
    print('🔄 Updating task at: $url');

    await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
  }

  /// Delete a task
  Future<void> deleteTask(String userId, String taskId) async {
    final url = Uri.parse('$dbUrl/$userId/$taskId.json');
    print('🗑️ Deleting task at: $url');

    await http.delete(url);
  }
}
