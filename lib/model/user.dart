
class User {
  final String email;
  final String userName;
  final String bio;
  final String uid;
  final String photoUrl;
  final List followers;
  final List following;

  const User(
      {required this.email,
      required this.userName,
      required this.bio,
      required this.uid,
      required this.photoUrl,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJason() => {
        'email': email,
        'username': userName,
        'bio': bio,
        'uid': uid,
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
      };
}
