import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final String photoUrl;

  const User(
      {required this.email,
      required this.photoUrl,
      required this.uid,
      required this.bio,
      required this.username,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'email': email,
    'bio': bio,
    'followers': followers,
    'following': following,
    'photoUrl': photoUrl,
  };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }


}
