import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_ui_backend_clone/resources/auth_methods.dart';
import 'package:instagram_ui_backend_clone/resources/firestore_methods.dart';
import 'package:instagram_ui_backend_clone/screens/login_screen.dart';
import 'package:instagram_ui_backend_clone/utils/colors.dart';
import 'package:instagram_ui_backend_clone/utils/utils.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  bool isFollowing = false;
  bool isLoading = false;
  int followers = 0;
  int following = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(Duration(seconds: 2),
    //   getData()
    // );
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postSnap.docs.length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      userData = userSnap.data() as dynamic;

      setState(() {
        followers = userData['followers'].length;
        following = userData['following'].length;
      });
    } catch (error) {
      showSnackBar(error.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: const CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                FirebaseAuth.instance.currentUser!.uid == widget.uid
                    ? InkWell(
                        //Show only if current user is checking his profile
                        child: Icon(Icons.menu),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              elevation: 10,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(30.0),
                              // ),
                              builder: (context) {
                                return Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        height: 3,
                                        width: 30,
                                      ),
                                      Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Colors.black54,
                                                      title: const Text(
                                                        'Logout',
                                                      ),
                                                      actions: [
                                                        InkWell(
                                                            onTap: () async {
                                                              await FirestoreMethods().signOut();
                                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                                                return const LoginScreen();
                                                              }));
                                                            },
                                                            child: const Icon(
                                                                Icons.logout, color: Colors.blue,)),
                                                      ],
                                                    );
                                                  });
                                            },
                                            leading: Icon(Icons.settings),
                                            title: Text('Settings'),
                                          ),
                                          ListTile(
                                            onTap: () {},
                                            leading: Icon(Icons.archive),
                                            title: Text('Archive'),
                                          ),
                                          ListTile(
                                            onTap: () {},
                                            leading:
                                                Icon(Icons.av_timer_rounded),
                                            title: Text('Your Activity'),
                                          ),
                                          ListTile(
                                            onTap: () {},
                                            leading: Icon(
                                                Icons.qr_code_scanner_outlined),
                                            title: Text('QR code'),
                                          ),
                                          ListTile(
                                            onTap: () {},
                                            leading: Icon(
                                                Icons.bookmark_border_outlined),
                                            title: Text('Saved'),
                                          ),
                                          ListTile(
                                            onTap: () {},
                                            leading: Icon(Icons
                                                .format_list_bulleted_outlined),
                                            title: Text('Close Friends'),
                                          ),
                                          ListTile(
                                            onTap: () {},
                                            leading: Icon(Icons.healing),
                                            title: Text(
                                                'COVID-19 Information Center'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  decoration: new BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(20.0),
                                          topRight:
                                              const Radius.circular(20.0))),
                                );
                              });
                        },
                      )
                    : Container()
              ],
              backgroundColor: kMobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            // endDrawer: Drawer(
            //   backgroundColor: kMobileBackgroundColor,
            //   child: Container(),
            //
            // ),
            // bottomSheet: BottomSheet(
            //   backgroundColor: Colors.white,
            //
            //     onClosing: (){},
            //     elevation: 3,
            //     builder: (context){
            //   return Container(
            //     height: 200,
            //   );
            // }),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, 'posts'),
                                    buildStatColumn(followers, 'Followers'),
                                    buildStatColumn(following, 'Following'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //TODO 5:57:26
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Edit Profile',
                                            backgroundColor:
                                                kMobileBackgroundColor,
                                            textColor: kPrimaryColor,
                                            borderColor: Colors.grey,
                                            function: () {},
                                          )
                                        : isFollowing
                                        ? FollowButton(
                                      text: 'Unfollow',
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      borderColor: Colors.grey,
                                      function: () async {
                                        await FirestoreMethods()
                                            .followUsers(
                                          FirebaseAuth.instance
                                              .currentUser!.uid,
                                          userData['uid'],
                                        );

                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      },
                                    )
                                        : FollowButton(
                                      text: 'Follow',
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      borderColor: Colors.blue,
                                      function: () async {
                                        await FirestoreMethods()
                                            .followUsers(
                                          FirebaseAuth.instance
                                              .currentUser!.uid,
                                          userData['uid'],
                                        );

                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Text(userData['bio']),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return Container(
                          child: Image(
                            image: NetworkImage(
                              snap['postUrl'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                      shrinkWrap: true,
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
