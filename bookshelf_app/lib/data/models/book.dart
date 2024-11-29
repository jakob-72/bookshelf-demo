class Book {
  final String id;
  final String title;
  final String author;
  final String? genre;
  final int? rating;
  final bool read;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.genre,
    this.rating,
    this.read = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'genre': genre,
        'rating': rating,
        'read': read,
      };

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        genre: json['genre'],
        rating: json['rating'],
        read: json['read'] ?? false,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
