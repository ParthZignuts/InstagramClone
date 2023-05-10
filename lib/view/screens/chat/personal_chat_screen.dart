import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/view/view.dart';

class PersonalChatScreen extends StatefulWidget {
  const PersonalChatScreen({Key? key,required this.userName,required this.profUrl}) : super(key: key);
final String userName;
final String profUrl;

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profUrl)),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child:  Text(widget.userName),
            ),
          ],
        ),
        leading: IconButton(onPressed: () =>Navigator.pop(context), icon: const Icon(CupertinoIcons.left_chevron)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam_rounded)),
        ],
      ),
      body: const Center(
        child: Text('Chat Here'),
      ),
      bottomSheet: Container(
        height: 70,
        color: Colors.black,
        child: Container(
          height: 20,
          margin: const EdgeInsets.only(left:8.0,bottom: 30),
          child: Form(
            child: SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width*0.95,
              child: TextFormField(
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.start,
                controller: chatController,
                decoration: const InputDecoration(

                  hintText: 'Message....',
                  contentPadding: EdgeInsets.only(bottom: 20),
                  prefixIcon: Icon(
                    Icons.search,
                    color: darkGray,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: darkGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: darkGray),
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
