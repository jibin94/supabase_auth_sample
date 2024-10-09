class NotesModel {
  final int id;
  final String title;
  final String description;

  NotesModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['id'],
      title: json['title'],
      description: json['description'].toString(),
    );
  }
}
