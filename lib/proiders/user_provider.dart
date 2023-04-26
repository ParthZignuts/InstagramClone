import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

import '../model/user.dart';

class UserProvider extends ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetail();
    _user = user;
    notifyListeners();
  }
}
