class TodoModel1 {
  final String title;

  TodoModel1({
    required this.title,
  });

  factory TodoModel1.fromJson(Map<String, dynamic> json) {
    return TodoModel1(
      title: json['title'],
    );
  }
}
