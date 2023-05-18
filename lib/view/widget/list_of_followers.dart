import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class Follower {
  final String uid;
  final String? username;
  final String? photoUrl;

  Follower({required this.uid, this.username, this.photoUrl});
}

class FollowersList extends StatelessWidget {
  final String uid;

  const FollowersList({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        var followersList = snapshot.data!.data()?['followers'] as List<dynamic>;

        return ListView.builder(
          itemCount: followersList.length,
          itemBuilder: (context, index) {
            var followerUid = followersList[index];
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('users').doc(followerUid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                var followerData = snapshot.data!.data();
                var follower = Follower(
                  uid: followerUid,
                  username: followerData?['userName'],
                  photoUrl: followerData?['photoUrl'],
                );

                return ListTile(
                  onTap: () => context.push('/SearchedUser/${followerData?['uid']}'),
                  title: Text(follower.username ?? ''),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(follower.photoUrl ?? ''),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
