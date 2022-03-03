import 'package:firebase_database/firebase_database.dart';
import 'package:herewego/model/post_model.dart';

class RTDBService {
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addPost(Post post) async {
    _database.child("posts").push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Post>> getPosts(String id) async {
    Query _query = _database.child("posts").orderByChild("userId").equalTo(id);
    var event = await _query.once();
    var result = event.snapshot.children;
    List<Post> items = result.map((snapshot) {
      Map<String, dynamic> post = Map<String, dynamic>.from(snapshot.value as Map);
      post['key'] = snapshot.key;
      return Post.fromJson(post);
    }).toList();
    return items;
  }

  static Future<Stream<DatabaseEvent>> update(Post post) async {
    _database.child("posts").child(post.key.toString()).update(post.toJson());
    return _database.onChildChanged;
  }

  static Future<Stream<DatabaseEvent>> delete(String key) async {
    _database.child("posts").child(key).remove();
    return _database.onChildRemoved;
  }
}
