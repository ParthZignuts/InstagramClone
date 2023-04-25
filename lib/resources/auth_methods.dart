import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage_mthods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///signUpUser Method
  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'You Got Some Error';
    try {
      if (email.isNotEmpty && password.isNotEmpty && userName.isNotEmpty && bio.isNotEmpty && file != null) {
        ///register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        /// add user to our database
        String photoUrl = await StorageMthods().uploadImageToStorage('profilePics', file, false);
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'userName': userName,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl
        });
        res = 'Success';
      }
    } catch (err) {
      res = err.toString();
      return res;
    }
    return res;
  }
}
