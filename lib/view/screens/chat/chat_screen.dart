import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/view/view.dart';
import '../../../core/core.dart';
import '../../../core/model/user.dart' as model;

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  ///creating a chatRoom for different users
  createChatRoom(String sender, String receiver) {
    String chatRoomId = getChatRoomId(sender, receiver);
    List<String> users = [sender, receiver];
    Map<String, dynamic> chatRoomMap = {
      'users': users,
      'chatRoomId': chatRoomId,
    };
    FireStoreMethods().createChatRoom(chatRoomId, chatRoomMap);
    return chatRoomId;
  }

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
        stream: FirebaseFirestore.instance.collection('users').where('userName', isNotEqualTo: user!.userName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Text('Loading...');
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final userName = documents[index]['userName'] ?? '';
              final photoUrl = documents[index]['photoUrl'] ?? '';
              final uid = documents[index]['uid'] ?? '';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    final chatId = createChatRoom(user!.userName, documents[index]['userName']);
                    context.pushNamed('PersonalChat', queryParameters: {
                      'userName': userName,
                      'photoUrl': photoUrl,
                      'uid': uid,
                      'chatRoomId': chatId,
                    });
                  },
                  child: ListTile(
                    title: Text(
                      userName,
                      style: const TextStyle(fontSize: 18),
                    ),
                    leading: CircleAvatar(
                      maxRadius: 24,
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

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
