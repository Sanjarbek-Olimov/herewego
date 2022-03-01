class Post {
  String userId;
  String name;
  DateTime date;
  String content;

  Post(this.userId, this.name, this.date, this.content);

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        name = json['name'],
        date = DateTime.parse(json['date']),
        content = json['content'];

  Map<String, dynamic> toJson() =>
      {
        'userId': userId,
        'name': name,
        'date': date.toString(),
        'content': content,
      };
}
