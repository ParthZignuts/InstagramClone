import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/core/resources/resources.dart';
import 'package:instagram_clone/view/view.dart';

class PersonalChatScreen extends StatefulWidget {
  const PersonalChatScreen(
      {Key? key, required this.userName, required this.photoUrl, required this.uid, required this.chatRoomId})
      : super(key: key);
  final String userName;
  final String photoUrl;
  final String uid;
  final String chatRoomId;

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  TextEditingController chatController = TextEditingController();
  late ScrollController _scrollController;
  bool isEnableToSend = false;
  bool _hasBuiltOnce = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
/// is used to scroll up messages list
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  ///enable or disable send button to send message
  changeStateOfSentMsg(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isEnableToSend = true;
      });
    } else {
      setState(() {
        isEnableToSend = false;
      });
    }
  }

  ///to send messages
  sendMessaged(String sendBy) {
    if (chatController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': chatController.text,
        'sendBy': sendBy,
        'timeStamp': DateTime.now(),
      };
      FireStoreMethods().addConversationsMessages(widget.chatRoomId, messageMap);
    }
    chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: GestureDetector(
          onTap: () => context.push('/SearchedUser/${widget.uid}'),
          child: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(widget.photoUrl)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.userName),
              ),
            ],
          ),
        ),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(CupertinoIcons.left_chevron)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam_rounded)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ChatRoom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy('timeStamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!_hasBuiltOnce) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    _hasBuiltOnce = true;
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Say Hello 👋👋'),
                    );
                  }

                  WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToBottom());

                  return ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot message = snapshot.data!.docs[index];
                      bool isSender = message['sendBy'] == widget.userName; // Replace 'sender' with your sender identifier

                      return Align(
                        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          constraints: const BoxConstraints(
                            maxWidth: 200.0,
                          ),
                          decoration: BoxDecoration(
                            color: isSender ? senderMsgBubbleColor : receiverMsgBubbleColor,
                            borderRadius: BorderRadius.only(
                              topLeft: isSender ? const Radius.circular(16.0) : const Radius.circular(0),
                              topRight: const Radius.circular(16.0),
                              bottomLeft: const Radius.circular(16.0),
                              bottomRight: isSender ? const Radius.circular(0) : const Radius.circular(16.0),
                            ),
                          ),
                          child: Text(
                            message['message'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 80,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4),
          child: Container(
            height: 10,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 30),
            child: Form(
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  onChanged: (value) => changeStateOfSentMsg(value),
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.start,
                  controller: chatController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Message....',
                    contentPadding: const EdgeInsets.only(bottom: 20),
                    prefixIcon: const Icon(
                      Icons.camera_alt_outlined,
                      color: primaryColor,
                    ),
                    suffixIcon: isEnableToSend
                        ? TextButton(
                            onPressed: () => sendMessaged(widget.userName),
                            child: const Text(
                              'Send',
                              style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                            ))
                        : SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.mic,
                                    color: primaryColor,
                                  ),
                                ),
                                IconButton(
                                  padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.photo,
                                    color: primaryColor,
                                  ),
                                ),
                                IconButton(
                                  padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.emoji_emotions,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: darkGray),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: darkGray),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}