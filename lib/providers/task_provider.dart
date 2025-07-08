import 'package:daily_do/models/task_model.dart';
import 'package:daily_do/services/task_services.dart';
import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String _userId = '';

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  void updateUser(String userId) {
    _userId = userId;
  }

  Future<void> loadTasks() async {
    if (_userId.isEmpty) return;
    _isLoading = true;
    notifyListeners();

    _tasks = await _taskService.fetchTasks(_userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    if (_userId.isEmpty) return;

    final task = TaskModel(id: "", title: title, isDone: false);
    await _taskService.addTask(_userId, task);
    await loadTasks(); // reload list
  }

  Future<void> updateTask(TaskModel task) async {
    await _taskService.updateTask(_userId, task);
    await loadTasks();
  }

  Future<void> toggleTask(TaskModel task) async {
    if (_userId.isEmpty) return;

    task.isDone = !task.isDone;
    await _taskService.updateTask(_userId, task);
    await loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    if (_userId.isEmpty) return;

    await _taskService.deleteTask(_userId, taskId);
    await loadTasks();
  }
}
