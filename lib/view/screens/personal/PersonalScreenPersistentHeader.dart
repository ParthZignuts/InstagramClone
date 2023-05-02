import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/view/widget/widget.dart';

class PersonalScreenPersistentHeader extends SliverPersistentHeaderDelegate {
  PersonalScreenPersistentHeader();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: [
        DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(
                    icon: Image.asset('assets/images/post.png',
                        color: primaryColor, width: 24),
                  ),
                  Tab(
                    icon: Image.asset('assets/images/reel.png',
                        color: primaryColor, width: 24),
                  ),
                  Tab(
                    icon: Image.asset('assets/images/tagpeople.png',
                        color: primaryColor, width: 24),
                  ),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    PersonalPostTab(),
                    MyReelsTab(),
                    TagedMeTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  double get maxExtent => 800.0;

  @override
  double get minExtent => 0.0;
}
