import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/view/widget/widget.dart';

class PostStreamBuilder extends StatelessWidget {
  const PostStreamBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          // check for null here
          return const Center(
            child: Text('No data available.'),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // final shuffledPost = shufflePost(snapshot);
              return PostCard(snap: snapshot.data!.docs[index].data());
            },
          );
        }
      },
    );
  }
  shufflePost(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
    final shuffledPost = List.from(snapshot.data!.docs)..shuffle();
    return shuffledPost;
  }
}
