import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/resources/storage_mthods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String caption,
      String uid,
      String userName,
      Uint8List file,
      String profImage) async {
     String result = 'Can\'t post now ';
    try {
      String postUrl = await StorageMthods().uploadImageToStorage('post', file, true);
      String postId = const Uuid().v1();
      PostModel post = PostModel(caption: caption,
          postId: postId,
          userName: userName,
          uid: uid,
          postUrl: postUrl,
          profImage: profImage,
          datePublished: DateTime.now(),
          likes: []);
      await _firestore.collection('posts').doc(post.postId).set(post.toJason());
      result='Success';
      return result;
    } catch (error) {
      result=error.toString();
    }
    return result;
  }

  Future<void> likePost(String postId, String uid, List likes, bool keepLike)async{
    try{
      if(likes.contains(uid) && !keepLike){
       await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      }
      else{
        await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid]),
        });
      }
    }
        catch(e){
      print(e.toString());
        }
  }
}
