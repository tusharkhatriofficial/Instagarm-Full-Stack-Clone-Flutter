import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_ui_backend_clone/resources/storage_methods.dart';
import 'package:instagram_ui_backend_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = 'Some error occured';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firebaseFirestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'Success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> LikePost(String postId, String uid, List likes) async {
    try{
      if(likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),//remove the uid from list of likes
        });
      }else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]), //add UID to list of likes
        });
      }
    }catch(error){
      print(error.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String username, String profilePic) async {
    try{
      if(text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firebaseFirestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
              'profilePic': profilePic,
          'name': username,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        }
            );
      }else{
        print("Blank comment can't be posted!");
      }
    }catch(error){
      print(error.toString());
    }
  }

  //deleting post

  Future<void> deletePost(String postId, BuildContext context) async {
    try{
      await _firebaseFirestore.collection('posts').doc(postId).delete();
    }catch(error){
      showSnackBar('Error deleting post! please try later.', context);
    }
  }

  //following functionality
  Future<void> followUsers(String uid, String followId) async {
    try{
      DocumentSnapshot snap = await _firebaseFirestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if(following.contains(followId)){
        //removing my uid from the followers of the other user bcz I clicked on the unfollow button
        await _firebaseFirestore.collection('users').doc(followId).update(
          {
            'followers': FieldValue.arrayRemove([uid]),
          });
        ////removing other persons uid from the my following bcz I clicked on the unfollow button
        await _firebaseFirestore.collection('users').doc(uid).update(
            {
              'following': FieldValue.arrayRemove([followId]),
            });
      }else{
        //Adding my uid to the followers of the other user bcz I clicked on the follow button
        await _firebaseFirestore.collection('users').doc(followId).update(
            {
              'followers': FieldValue.arrayUnion([uid]),
            });
        ////Adding other persons uid to my following bcz I clicked on the follow button
        await _firebaseFirestore.collection('users').doc(uid).update(
            {
              'following': FieldValue.arrayUnion([followId]),
            });
      }
    }catch(error){
      print(error.toString());
    }
  }


  //Signout Function
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }


}
