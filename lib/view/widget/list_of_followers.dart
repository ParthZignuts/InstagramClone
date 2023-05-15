import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/view/view.dart';

class ListOfFollowers extends StatefulWidget {
  const ListOfFollowers({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<ListOfFollowers> createState() => _ListOfFollowersState();
}

class _ListOfFollowersState extends State<ListOfFollowers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('users').doc(widget.userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('User not found');
        }

        Map<String, dynamic>? userData = snapshot.data!.data();

        if (userData != null) {
          List<String> followers = List<String>.from(userData['followers'] ?? []);
          List<String> photoUrl = List<String>.from(userData['photoUrl'] ?? []);
          List<String> userName = List<String>.from(userData['userName'] ?? []);

          // Use the 'followers' and 'following' lists as needed
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(userName[index]),
                leading: CircleAvatar(backgroundImage: NetworkImage(photoUrl[index])),
              );
            },
          );
        }

        return Text('User data is empty');
      },
    );
  }
}
