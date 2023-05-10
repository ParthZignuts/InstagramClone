import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/view/view.dart';
import '../../../core/core.dart';
import '../../../core/model/user.dart' as model;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Map<String, dynamic>? currentUserStory;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    model.User? user = userProvider.getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(user!.userName),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call_outlined, size: 30)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit, size: 25)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Text('Loading...');
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final userName = documents[index]['userName'] ?? '';
              final photoUrl = documents[index]['photoUrl'] ?? '';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Get.to(PersonalChatScreen(
                    userName: userName,
                    profUrl: photoUrl,
                  )),
                  child: ListTile(
                    title: Text(
                      userName,
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: CircleAvatar(
                      maxRadius: 28,
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
