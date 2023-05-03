import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/proiders/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/view/widget/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../resources/resources.dart';
import '../../utils/colors.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    required this.snap,
    super.key,
  });

  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimating = false;
  String _userName = '';
  String _photoUrl = '';

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    _photoUrl = user.photoUrl;
    _userName = user.userName;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['userName'],
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Gandhinagar Gujrat',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(widget.snap['postId'], user.uid, widget.snap['likes'], true);
              setState(() {
                isAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(widget.snap['photoUrl'], fit: BoxFit.fill),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FireStoreMethods().likePost(widget.snap['postId'], user.uid, widget.snap['likes'], false);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border),
                ),
              ),
              IconButton(onPressed: () => _showCommentsBottomSheet(), icon: const Icon(CupertinoIcons.bubble_right)),
              Transform.rotate(
                angle: 610 * pi / 330,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                      )),
                ),
              ),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.bookmark)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    children: [
                      Text(
                        '${widget.snap['userName']}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${widget.snap['caption']}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                  style: const TextStyle(fontWeight: FontWeight.w400, color: secondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,

      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
             keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: SafeArea(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  // Check if the user is scrolling down and the keyboard is closed
                  if (details.delta.dy > 0 && !MediaQuery.of(context).viewInsets.bottom.isNegative) {
                    // Dismiss the bottom sheet
                    Get.back();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: darkGray,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24.0),
                      topLeft: Radius.circular(24.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 4,
                            width: 50,
                            color: secondaryColor,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 8.0),
                            child: Text(
                              'Comments',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(color: Colors.white, height: 3),
                        ],
                      ),
                      SizedBox(
                        height: 650,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 30,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text('Comments: $index'),
                            );
                          },
                        ),
                      ),
                      TextFormField(
                        // autofocus: true,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(_photoUrl),
                            ),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Text(
                                'Post',
                                style: TextStyle(color: Colors.blue),
                              )),
                          hintText: 'Add a comment for ...${widget.snap['userName']}',
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
