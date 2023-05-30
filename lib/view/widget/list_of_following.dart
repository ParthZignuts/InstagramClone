import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../view.dart';

class Following {
  final String uid;
  final String? username;
  final String? photoUrl;

  Following({required this.uid, this.username, this.photoUrl});
}

class FollowingList extends StatelessWidget {
  final String uid;

  const FollowingList({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        var followersList = snapshot.data!.data()?['following'] as List<dynamic>;

        return followersList.isEmpty
            ? Center(
                child: Text(
                  'No Users Found!',
                  style: TextStyles.h2Normal.copyWith(color: mobileBackgroundColor),
                ),
              )
            : ListView.builder(
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
                      var follower = Following(
                        uid: followerUid,
                        username: followerData?['userName'],
                        photoUrl: followerData?['photoUrl'],
                      );

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                        child: ListTile(
                          onTap: () => context.push('/SearchedUser/${followerData?['uid']}'),
                          title: Text(follower.username ?? ''),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(follower.photoUrl ?? ''),
                            radius: 28,
                          ),
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
