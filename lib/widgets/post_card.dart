import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_ui_backend_clone/resources/firestore_methods.dart';
import 'package:instagram_ui_backend_clone/screens/comments_screen.dart';
import 'package:instagram_ui_backend_clone/utils/colors.dart';
import 'package:instagram_ui_backend_clone/utils/utils.dart';
import 'package:instagram_ui_backend_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:instagram_ui_backend_clone/models/users.dart' as model;
import '../providers/user_provider.dart';
import '../utils/dimensions.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (error) {
      showSnackBar(error.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: MediaQuery.of(context).size.width > webScreenSize? kSecondaryColor: kMobileBackgroundColor,
        ),
        color: kMobileBackgroundColor,
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //header section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16.0,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shrinkWrap: true,
                          children: [
                            user.uid == widget.snap['uid'] ?
                            'Delete': 'Report'
                          ]
                              .map(
                                (e) => InkWell(
                                  onTap: () async {
                                    user.uid == widget.snap['uid'] ?
                                    FirestoreMethods().deletePost(widget.snap['postId'], context):
                                        print("report");//TODO add report functionality here
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 16.0),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          //image section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().LikePost(widget.snap['postId'], user.uid,
                  widget.snap['likes']); //TODO updating likes
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Like, Comment Section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                //TODO
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().LikePost(widget.snap['postId'],
                          user.uid, widget.snap['likes']); //TODO updating likes
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_outline,
                          )),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentsScreen(snap: widget.snap),
                  ));
                  // Navigator.pushNamed(context, '/comments_screen');
                  // Navigator.push(context, MaterialPageRoute(builder: (context){
                  //   return CommentsScreen(snap: widget.snap['postId'].toString(),);
                  // }));
                },
                icon: const Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {
                      //TODO Bookmark functionality
                    },
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ),
              ),
            ],
          ),
          // caption/description and no of comments section
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: kPrimaryColor),
                      children: [
                        TextSpan(
                          text: 'Tushar Khatri',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ' + widget.snap['description'],
                        ),
                      ],
                    ),
                  ),
                ),
                //TODO add functionality of clicking on view comments below
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsScreen(snap: widget.snap),
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      commentLen == 0
                          ? 'Be the first one to comment on this post'
                          : commentLen == 1
                              ? 'View ${commentLen} comment'
                              : 'View all ${commentLen} comments',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
                ),
                //TODO implement date below
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    // DateFormat.yMMMd().format(snap['datePublished'].toDate()
                    DateFormat.yM()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: kSecondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
