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
}
