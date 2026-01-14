class Task {
  String title;
  String status;

  Task({
    required this.title,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      status: json['status'],
    );
  }
}
