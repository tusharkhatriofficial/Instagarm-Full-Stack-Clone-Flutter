import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_ui_backend_clone/utils/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/dimensions.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MediaQuery.of(context).size.width > webScreenSize? kWebBackgroundColor: kMobileBackgroundColor,
      appBar: MediaQuery.of(context).size.width > webScreenSize? null:
      AppBar(
        backgroundColor: kMobileBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SvgPicture.asset(
            'assets/images/ic_instagram.svg',
            color: kPrimaryColor,
            height: 32,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Icon(
              Icons.add_box_outlined,
              // size: 30,
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Badge(
              child: const Icon(
                FontAwesomeIcons.facebookMessenger,
                // size: 30,
              ),
              badgeColor: Colors.red,
              badgeContent: Text(
                '10',
                style: TextStyle(height: 1),
              ),
              position: BadgePosition.topEnd(),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),

      // body: const PostCard(),
      body: StreamBuilder(
        stream: FirebaseFirestore
            .instance
            .collection('posts').orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            print('none');
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > webScreenSize?  MediaQuery.of(context).size.width*0.3:
              0, vertical: MediaQuery.of(context).size.width > webScreenSize? 15: 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
