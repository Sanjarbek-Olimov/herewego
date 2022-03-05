class Post {
  String? key;
  String userId;
  String name;
  DateTime date;
  String content;
  String? image;
  bool isVideo;

  Post({required this.userId, required this.name, required this.date, required this.content, this.image, this.key, required this.isVideo});

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        name = json['name'],
        date = DateTime.parse(json['date']),
        content = json['content'],
        key = json['key'],
        isVideo = json['isVideo'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'date': date.toString(),
        'content': content,
        'image': image,
        'isVideo': isVideo,
      };
}
