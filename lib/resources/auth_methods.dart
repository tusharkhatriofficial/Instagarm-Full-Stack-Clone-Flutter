import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_ui_backend_clone/models/users.dart' as model;
import 'package:instagram_ui_backend_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //user state management using provider
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  //Signup the user
  Future<String> SignUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //Register User
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        //add user to our database

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        // await _firestore.collection('users').doc(cred.user!.uid).set({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        //   'photoUrl': photoUrl,
        // });
        // so I made the User class in models folder to model the user
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);
        res = 'Success';
      }
    } // on FirebaseAuthException will be here
    catch (error) {
      res = error.toString();
    }
    return res;
  }

  //login user
  Future<String> loginUser({required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //login User
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      }else{
        res = "Please enter the right credentials!";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }


}
