import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/core/resources/storage_mthods.dart';
import '../model/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///get the CurrentUser details
  Future<model.User> getUserDetail() async {
    User? currentUser = _auth.currentUser;
    print(currentUser);
    if (currentUser != null) {
      DocumentSnapshot? snap = await _firestore.collection('users').doc(currentUser.uid).get();
      if (snap != null && snap.exists) {
        return model.User.fromSnap(snap);
      } else {
        throw Exception("User snapshot is null or does not exist");
      }
    } else {
      throw Exception("Current user is null");
    }
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

  ///Update user profile
  Future<String> updateUser({
    required String uid,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Please Fill All The Form Field!!';
    try {
      if (userName.isNotEmpty && bio.isNotEmpty && file != null) {
        // Update user data
        String photoUrl = await StorageMthods().uploadImageToStorage('profilePics', file, false);

        // Retrieve the user document from the database
        DocumentReference userRef = _firestore.collection('users').doc(uid);
        DocumentSnapshot userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          // Update the user document
          await userRef.update({
            'bio': bio,
            'photoUrl': photoUrl,
            'userName': userName,
          });
          res = 'Success';
        } else {
          res = 'User not found';
        }
      }
    } catch (err) {
      res = err.toString();
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
/// For SignOut To user account
  Future<void> signOut() async {
    await _auth.signOut();
  }

//   ///push notifications
//   static FirebaseMessaging messaging=FirebaseMessaging.instance;
// late String fcmToken;
//   ///for getting firebase messaging token
//   static Future<void> getFirebaseMessagingToken()async {
//     await messaging.requestPermission();
//      messaging.getToken().then((value) {if(value !=null){
//       print(value);
//     }} );
//   }
}
