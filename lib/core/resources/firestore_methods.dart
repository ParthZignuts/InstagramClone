import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/core/resources/storage_mthods.dart';
import 'package:uuid/uuid.dart';
import '../model/model.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///to upload post
  Future<String> uploadPost(String caption, String uid, String userName, Uint8List file, String profImage) async {
    String result = 'Can\'t post now ';
    try {
      String postUrl = await StorageMthods().uploadImageToStorage('post', file, true);
      String postId = const Uuid().v1();
      PostModel post = PostModel(
          caption: caption.trim(),
          postId: postId,
          userName: userName,
          uid: uid,
          postUrl: postUrl,
          profImage: profImage,
          datePublished: DateTime.now(),
          likes: []);
      await _firestore.collection('posts').doc(post.postId).set(post.toJason());
      result = 'Success';
      return result;
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// add likes on post
  Future<void> likePost(String postId, String uid, List likes, bool keepLike) async {
    try {
      if (likes.contains(uid) && !keepLike) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  ///to do comments on post
  Future<String> postComment(String postId, String text, String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// for deleting comments on post
  Future<String> deleteComments(String postId, String commentId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  ///to delete the post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  ///to manage followers
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
