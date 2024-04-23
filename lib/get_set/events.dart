class Evvent {
  final String title;
  final String description;
  final String? imageUrl; // Make imageUrl nullable
  int likes;
  bool isNotified;
  DateTime deadline; // Optional

  Evvent({
    required this.title,
    required this.description,
    this.imageUrl,
    this.likes = 0,
    this.isNotified = false,
    required this.deadline,
  });
}