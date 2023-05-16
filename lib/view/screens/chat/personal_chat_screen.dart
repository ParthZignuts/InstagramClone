import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/view/view.dart';

class PersonalChatScreen extends StatefulWidget {
  const PersonalChatScreen({Key? key, required this.userName, required this.photoUrl, required this.uid}) : super(key: key);
  final String userName;
  final String photoUrl;
  final String uid;

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  TextEditingController chatController = TextEditingController();
  bool isEnableToSend = false;

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
      body: const Center(
        child: Text('Chat Here'),
      ),
      bottomSheet: Container(
        height: 80,
        color: Colors.black,
        child: Container(
          height: 10,
          width: MediaQuery.of(context).size.width * 0.96,
          margin: const EdgeInsets.only(left: 8.0, bottom: 30),
          child: Form(
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.95,
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
                          onPressed: () {},
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
    );
  }
}
