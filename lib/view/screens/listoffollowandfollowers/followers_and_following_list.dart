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
            backgroundColor: mobileBackgroundColor,
            title:  Text(userName),
            bottom: const TabBar(
              indicatorColor: primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  icon: Text(
                    "followers",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Tab(
                  icon: Text(
                    'following',
                    style: TextStyle(fontSize: 18),
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
