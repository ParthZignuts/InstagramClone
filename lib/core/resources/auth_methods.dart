import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/core/resources/storage_mthods.dart';
import '../model/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///get the Currentuser details
  Future<model.User> getUserDetail() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  ///signUpUser Method
  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Please Fill All The Form Field!!';
    try {
      if (email.isNotEmpty && password.isNotEmpty && userName.isNotEmpty && bio.isNotEmpty && file != null) {
        ///register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        String photoUrl = await StorageMthods().uploadImageToStorage('profilePics', file, false);

        ///use User Model to store data
        model.User user = model.User(
            bio: bio, email: email, followers: [], following: [], photoUrl: photoUrl, uid: cred.user!.uid, userName: userName);

        /// add user to our database
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJason());
        res = 'Success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code.isEmpty) {
        res = 'Success';
      } else {
        res = err.message.toString();
      }
      return res;
    }
    return res;
  }

  ///Logging User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String isValid = 'Invalid User!';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        isValid = 'Login Successfully';
      } else {
        isValid = 'Please Enter All The Field';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code.isEmpty) {
        isValid = 'Login Successfully';
      } else {
        isValid = err.message.toString();
      }
      return isValid;
    }
    return isValid;
  }
}
