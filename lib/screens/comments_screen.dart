import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_ui_backend_clone/resources/firestore_methods.dart';
import 'package:instagram_ui_backend_clone/screens/profile_screen.dart';
import 'package:instagram_ui_backend_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/comment_card.dart';
import 'package:instagram_ui_backend_clone/models/users.dart' as model;

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: TextButton(
                    onPressed: () async {
                      await FirestoreMethods().postComment(
                          widget.snap['postId'],
                          _commentController.text,
                          user.uid,
                          user.username,
                          user.photoUrl);
                      setState(() {
                        _commentController.clear();
                      });
                    }, //TODO implement comment post here
                    child: const Text(
                      'Post',
                      style: TextStyle(color: kBlueColor),
                    )),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => InkWell(
              onTap: (){
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ProfileScreen(
                    uid: (snapshot.data! as dynamic).docs[index]
                    ['uid'],
                  );
                }));
              },
              child: CommentCard(
                snap: (snapshot.data! as dynamic).docs[index].data()
              ),
            ),
          );
        },
      ),
    );
  }
}
