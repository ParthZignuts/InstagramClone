import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/view/view.dart';

class PostDetailedView extends StatefulWidget {
  const PostDetailedView({Key? key, required this.postId}) : super(key: key);
  final String postId;

  @override
  State<PostDetailedView> createState() => _PostDetailedViewState();
}

class _PostDetailedViewState extends State<PostDetailedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Posts',
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.left_chevron),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: StreamBuilder<List<QueryDocumentSnapshot>>(
                stream: getPostAsStream(widget.postId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  List<QueryDocumentSnapshot> postDocs = snapshot.data!;
                  QueryDocumentSnapshot postDoc = postDocs[0]; // Get the first document in the list
                  Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>; // Get the data as a Map
                  return PostCard(snap: postData);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<QueryDocumentSnapshot>> getPostAsStream(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('postId', isEqualTo: postId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs);
  }
}
