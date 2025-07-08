class TaskModel {
  final String id;
  final String title;
  bool isDone;

  TaskModel({required this.id, required this.title, required this.isDone});

  factory TaskModel.fromJson(Map<String, dynamic> json, String id) {
    return TaskModel(id: id, title: json['title'], isDone: json['isDone']);
  }

  Map<String, dynamic> toJson() => {'title': title, 'isDone': isDone};

  TaskModel copyWith({String? id, String? title, bool? isDone}) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
