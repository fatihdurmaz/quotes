class Quote {
  final int id;
  final String quote;
  final String author;

  Quote({required this.id, required this.quote, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
    id: json["id"] as int,
    quote: json["quote"] as String,
    author: json["author"] as String,
  );

  Map<String, dynamic> toJson() => {"id": id, "quote": quote, "author": author};
}
