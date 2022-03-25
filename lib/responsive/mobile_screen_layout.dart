import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_ui_backend_clone/providers/user_provider.dart';
import 'package:instagram_ui_backend_clone/screens/add_post_screen.dart';
import 'package:instagram_ui_backend_clone/screens/feed_screen.dart';
import 'package:instagram_ui_backend_clone/screens/profile_screen.dart';
import 'package:instagram_ui_backend_clone/screens/search_screen.dart';
import 'package:instagram_ui_backend_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:instagram_ui_backend_clone/models/users.dart' as model;
class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

  int _page = 0; //for bottom navigation bar

  late PageController pageController;
  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }



  @override
  Widget build(BuildContext context) {
      model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: kMobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: _page == 0? kPrimaryColor: kSecondaryColor,),
              label: '',
              backgroundColor: kPrimaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: _page == 1? kPrimaryColor: kSecondaryColor,),
              label: '',
              backgroundColor: kPrimaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, color: _page == 2? kPrimaryColor: kSecondaryColor,),
              label: '',
              backgroundColor: kPrimaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: _page == 3? kPrimaryColor: kSecondaryColor,),
              label: '',
              backgroundColor: kPrimaryColor),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.person, color: _page == 4? kPrimaryColor: kSecondaryColor,),
          //     label: '',
          //     backgroundColor: kPrimaryColor),
          BottomNavigationBarItem(
              icon: CircleAvatar(backgroundImage: NetworkImage(user.photoUrl),),
              label: '',
              backgroundColor: kPrimaryColor),
        ],
        onTap: navigationTapped,
      ),
      body: PageView(
        children: [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          Text("Favorite tapped"),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
