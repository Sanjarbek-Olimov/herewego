import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/pages/view_image.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/database_service.dart';
import 'package:herewego/services/hive_service.dart';

import 'account_settings.dart';
import 'details_page.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";
  User user;

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

  Future _openDetail() async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DetailPage();
    }));
    if (results.containsKey("data")) {
      _apiGetPosts();
    }
  }

  Future _openDetailforEdit(Post post) async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DetailPage(
        post: post,
      );
    }));
    if (results.containsKey("data")) {
      _apiGetPosts();
    }
  }

  _apiGetPosts() async {
    setState(() {
      isLoading = true;
    });
    var id = HiveDB.loadUid();
    RTDBService.getPosts(id!).then((posts) => {
          _respPosts(posts),
        });
  }

  _respPosts(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Posts"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                AuthService.signOutUser(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.red),
              accountEmail: Text(widget.user.email!),
              accountName: Text(widget.user.displayName!),
              currentAccountPicture: const Icon(
                Icons.account_circle,
                size: 80,
                color: Colors.white,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AccountSettings.id);
              },
              child: const ListTile(
                textColor: Colors.black,
                leading: Icon(
                  Icons.settings,
                  size: 25,
                  color: Colors.red,
                ),
                horizontalTitleGap: 0,
                title: Text(
                  "Account settings",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ))
          : items.isEmpty
              ? const Center(
                  child: Text(
                    "No posts",
                    style: TextStyle(fontSize: 22),
                  ),
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return posts(items[index]);
                  }),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetail,
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget posts(Post post) {
    return Dismissible(
      key: const ValueKey(0),
      onDismissed: (DismissDirection) {
        RTDBService.delete(post.key!);
        setState(() {
          items.remove(post);
        });
      },
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 100,
        ),
      ),
      child: InkWell(
        onTap: () {
          _openDetailforEdit(post);
        },
        onLongPress: () {
          if (post.image != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ViewImage(url: post.image!)));
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              post.image == null
                  ? Image.asset(
                      "assets/images/image_default.png",
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      post.image!,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(
                height: 5,
              ),
              Text(
                post.name,
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                post.date.toString().substring(0, 10),
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                post.content,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
