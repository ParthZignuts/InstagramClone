import 'package:go_router/go_router.dart';
import 'package:instagram_clone/view/screens/search/searched_user_profillescreen.dart';
import '../view/view.dart';

/// The route configuration.

final router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
      path: "/MainScreen",
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 450),
            key: state.pageKey,
            child: const MainScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: CurveTween(curve: Curves.easeIn).animate(animation), child: child);
            });
      }),
  GoRoute(
      path: "/ChatScreen",
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 450),
            key: state.pageKey,
            child: const ChatScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: CurveTween(curve: Curves.easeIn).animate(animation), child: child);
            });
      }),
  GoRoute(
      path: "/ListOfFollowing",
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 450),
            key: state.pageKey,
            child: const ListOfFollowersAndFollowing(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: CurveTween(curve: Curves.easeIn).animate(animation), child: child);
            });
      }),
  GoRoute(
      path: "/CommentScreen/:postId",
      builder: (context, state) => CommentsScreen(
            postId: state.pathParameters['postId']!,
          )),
  GoRoute(path: "/LoginScreen", builder: (context, state) => const LoginScreen()),
  GoRoute(path: "/SignUpScreen", builder: (context, state) => const SignUpScreen()),
  GoRoute(
      name: 'PersonalChat',
      path: "/PersonalChat",
      builder: (context, state) => PersonalChatScreen(
            userName: state.queryParameters['userName']!,
            photoUrl: state.queryParameters['photoUrl']!,
            uid: state.queryParameters['uid']!,
          )),
  GoRoute(
    path: "/SearchScreen",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 450),
          key: state.pageKey,
          child: const SearchScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );
            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          });
    },
  ),
  GoRoute(
    path: "/PostDetailedView/:postId",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 450),
          child: PostDetailedView(postId: state.pathParameters['postId']!),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );
            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          });
    },
  ),
  GoRoute(
      path: "/SearchedUser/:uid",
      builder: (context, state) => SearchedUserProfileScreen(
            uid: state.pathParameters['uid']!,
          )),
]);
