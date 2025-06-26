class AddBookRequest {
  final String title;
  final String author;
  final String? genre;
  final int? rating;
  final bool read;

  AddBookRequest({
    required this.title,
    required this.author,
    this.genre,
    this.rating,
    required this.read,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    'genre': genre,
    'rating': rating,
    'read': read,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddBookRequest &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          author == other.author;

  @override
  int get hashCode => title.hashCode ^ author.hashCode;
}
