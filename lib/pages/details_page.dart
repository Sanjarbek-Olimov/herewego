import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/services/database_service.dart';
import 'package:herewego/services/hive_service.dart';
import 'package:herewego/services/store_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  static const String id = "detail_page";
  Post? post;

  DetailPage({Key? key, this.post}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var isLoading = false;
  File? image;
  final picker = ImagePicker();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var dateController = TextEditingController();
  var contentController = TextEditingController();

  _addPost() async {
    String firstName = firstNameController.text.trim().toString();
    String lastName = lastNameController.text.trim().toString();
    String content = contentController.text.trim().toString();
    DateTime date = DateTime.parse(dateController.text.trim().toString());
    if (dateController.text.isEmpty ||
        content.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) return;
    _apiUploadImage(firstName + " " + lastName, date, content);
  }

  _apiUploadImage(String name, DateTime date, String content) {
    setState(() {
      isLoading = true;
    });
    if (widget.post != null) {
      image != null ?
      StoreService.uploadImage(image).then((image) =>
      {
        _apiUpdatePost(name, date, content, image)
      }) : _apiUpdatePost(name, date, content, widget.post!.image);
    }
    else {
      StoreService.uploadImage(image).then((image) =>
      {
        _apiAddPost(name, date, content, image)
      });
    }
  }

  _apiAddPost(String name, DateTime date, String content, String? image) async {
    var id = HiveDB.loadUid();
    RTDBService.addPost(Post(userId: id!,
        name: name,
        content: content,
        date: date,
        image: image)).then((response) =>
    {
      _respAddPost(),
    });
  }

  _apiUpdatePost(String name, DateTime date, String content,
      String? image) async {
    RTDBService.update(
        Post(userId: widget.post!.userId,
            key: widget.post!.key,
            name: name,
            date: date,
            content: content,
            image: image)).then((response) =>
    {
      _respAddPost(),
    });
  }

  _respAddPost() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop({'data': 'done'});
  }

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.post != null) {
      setState(() {
        firstNameController.text = widget.post!.name.split(" ")[0];
        lastNameController.text = widget.post!.name.split(" ")[1];
        contentController.text = widget.post!.content;
        dateController.text = widget.post!.date.toString().substring(0, 10);
      });
    }
  }

  void _androidDialog() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Delete image"),
        content: const Text("Are you sure to delete the image?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.red, fontSize: 16),)),
          TextButton(onPressed: () {
            setState(() {
              if (widget.post!.image != null) {
                FirebaseStorage.instance.refFromURL(
                    widget.post!.image!).delete();
              } else if (image != null) {
                image!.delete();
              }
              widget.post!.image = null;
              Navigator.pop(context);
            });
          }, child: const Text("Confirm", style: TextStyle(fontSize: 16),)),
        ],

      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.post != null ? "Update Post" : "Add Post"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          isLoading
              ? const Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          )
              : const SizedBox.shrink(),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  InkWell(
                    onTap: _getImage,
                    onLongPress: () {
                      if (widget.post!.image != null || image != null) {
                        _androidDialog();
                      }
                    },
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: image != null ?
                      Image.file(image!, fit: BoxFit.cover)
                          : widget.post == null || widget.post!.image == null
                          ? Image.asset(
                          "assets/images/image_detail.jpg")
                          : Image.network(
                        widget.post!.image!, fit: BoxFit.cover,),
                    ),
                  ),
                  TextField(
                    textInputAction: TextInputAction.next,
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red, width: 2
                          )
                      ),
                      hintText: "First Name",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    textInputAction: TextInputAction.next,
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red, width: 2
                          )
                      ),
                      hintText: "Last Name",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    textInputAction: TextInputAction.next,
                    controller: contentController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red, width: 2
                          )
                      ),
                      hintText: "Content",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red, width: 2
                          )
                      ),
                      hintText: "Date",
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Colors.red, // body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary: Colors.red, // button text color
                                  ),
                                ),
                              ), child: child!,
                            )
                          }
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          dateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: MaterialButton(
                      onPressed: _addPost,
                      color: Colors.red,
                      child: Text(
                        widget.post != null ? "Update" : "Add",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
