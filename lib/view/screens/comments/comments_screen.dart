import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/core/controller/comments_controller.dart';
import '../../view.dart';
import '../../../core/core.dart';

class CommentsScreen extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final postId;

  CommentsScreen({Key? key, required this.postId}) : super(key: key);

  // TextEditingController commentEditingController = TextEditingController();
  final CommentsController _commentsController = Get.put(CommentsController());

  /// to add comment on post
  void postComment(String uid, String name, String profilePic, BuildContext context) async {
    try {
      String res = await FireStoreMethods().postComment(
        postId,
        _commentsController.commentEditingController.value.text,
        uid,
        name,
        profilePic,
      );
      if (res != 'success') {
        // ignore: use_build_context_synchronously
        showSnackbar(res, context);
      }

      _commentsController.updateControllerValue('');
    } catch (err) {
      showSnackbar(
        err.toString(),
        context,
      );
    }
  }

  ///delete selected comment
  void deleteComment(String postId, String commentId, String uid) {
    FireStoreMethods().deleteComments(postId, commentId, uid);
  }

  ///comments stream
  Stream<QuerySnapshot<Map<String, dynamic>>> commentsStream() => FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .orderBy('datePublished', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        title: const Text(
          'Comments',
          style: TextStyle(color: mobileBackgroundColor),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.left_chevron,
            color: mobileBackgroundColor,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: commentsStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!_commentsController.hasBuiltOnce.value) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            _commentsController.changeValueOfHasBuiltOnce(true);
          }
          return (snapshot.data!.docs.isNotEmpty)
              ? GestureDetector(
                  onPanDown: (_) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) => CommentCard(
                      snap: snapshot.data!.docs[index],
                      onDelete: () => deleteComment(postId, snapshot.data!.docs[index].data()['commentId'], user!.uid),
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    'No Any Comments!',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: mobileBackgroundColor),
                  ),
                );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    autofocus: true,
                    controller: _commentsController.commentEditingController.value,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.userName}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => postComment(user.uid, user.userName, user.photoUrl, context),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
