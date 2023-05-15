
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:instagram_clone/view/view.dart';

class ListOfFollowersAndFollowing extends StatefulWidget {
  const ListOfFollowersAndFollowing({Key? key}) : super(key: key);

  @override
  State<ListOfFollowersAndFollowing> createState() => _ListOfFollowersAndFollowingState();
}

class _ListOfFollowersAndFollowingState extends State<ListOfFollowersAndFollowing> with TickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: mobileBackgroundColor,
            title: const Text('UserName'),
            bottom: const TabBar(
              tabs: [
              Tab(
                icon: Text("followers",style: TextStyle(fontSize: 18),),
              ),
                Tab(
                icon: Text('following',style: TextStyle(fontSize: 18),),
              ),
              ],
            ),
          ),
          body:  const TabBarView(
            physics: BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            children: [
              Text('Followers'),
              Text('Following'),
            ],
          ),
        ),
      ),
    );
  }
}

