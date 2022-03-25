import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_ui_backend_clone/screens/profile_screen.dart';
import 'package:instagram_ui_backend_clone/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../utils/dimensions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kMobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              label: Text('Search for a user'),
            ),
            // onFieldSubmitted: (String _){
            //   setState(() {
            //     isShowUsers = true;
            //   });
            // },
            onChanged: (String _) {
              _ != ''
                  ? setState(() {
                      isShowUsers = true;
                    })
                  : setState(() {
                      isShowUsers = false;
                    });
            },
          ),
        ),
        body: isShowUsers == true
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: (context, snapsot) {
                  if (!snapsot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapsot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapsot.connectionState ==
                      ConnectionState.waiting) {
                    //TODO this solved  Bad state: field does not exist within the DocumentSnapshotPlatform error
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    itemCount: (snapsot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ProfileScreen(
                              uid: (snapsot.data! as dynamic).docs[index]
                                  ['uid'],
                            );
                          }));
                        },
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  (snapsot.data! as dynamic).docs[index]
                                      ['photoUrl']),
                            ),
                            title: Text((snapsot.data! as dynamic).docs[index]
                                ['username'])),
                      );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.network(
                          (snapshot.data as dynamic).docs[index]['postUrl'],
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                    staggeredTileBuilder: (index) => MediaQuery.of(context).size.width > webScreenSize? StaggeredTile.count(
                        (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                        :StaggeredTile.count(
                        (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  );
                },
              ));
  }
}
