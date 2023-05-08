import 'package:flutter/cupertino.dart';
import '../view.dart';
import '../../core/core.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.getUser;
    return (user == null)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) => onPageChanged(value),
              controller: pageController,
              children: [
                const FeedScreen(),
                const SearchScreen(),
                const AddPostScreen(),
                const ReelsScreen(),
                ProfileScreen(uid: user.uid),
              ],
            ),
            bottomNavigationBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: _page == 0 ? primaryColor : secondaryColor,
                  ),
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: _page == 1 ? primaryColor : secondaryColor,
                  ),
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle, color: _page == 2 ? primaryColor : secondaryColor),
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/reel.png', color: _page == 3 ? primaryColor : secondaryColor, width: 24),
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: CircleAvatar(backgroundImage: NetworkImage(user.photoUrl), radius: 16),
                  backgroundColor: primaryColor,
                ),
              ],
              backgroundColor: Colors.transparent,
              onTap: navigationTapped,
              height: 60,
            ),
          );
  }
}
