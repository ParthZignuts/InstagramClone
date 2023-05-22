import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:instagram_clone/view/view.dart';

class FollowersAndFollowingList extends StatelessWidget {
  const FollowersAndFollowingList({Key? key, required this.uid,required this.userName}) : super(key: key);
  final String uid;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: scaffoldBackgroundColor,
            elevation: 0,
            title:  Text(userName,style: const TextStyle(color: mobileBackgroundColor),),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.left_chevron,color: mobileBackgroundColor,),
            ),
            bottom: const TabBar(
              indicatorColor: mobileBackgroundColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  icon: Text(
                    "followers",
                    style: TextStyle(fontSize: 18,color: mobileBackgroundColor),
                  ),
                ),
                Tab(
                  icon: Text(
                    'following',
                    style: TextStyle(fontSize: 18,color: mobileBackgroundColor),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            children: [
              FollowersList(uid: uid),
              FollowingList(uid: uid),
            ],
          ),
        ),
      ),
    );
  }
}