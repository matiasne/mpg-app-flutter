import 'package:mpg_mobile/constants/enum/subscription_type_enum.dart';
import 'package:mpg_mobile/constants/errors.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/http_error.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mpg_mobile/services/api/users_service.dart';

class AuthenticationService {
  final _usersService = locator<UsersService>();
  LocalStorage storage = LocalStorage('mpg.json');

  User? _currentUser;
  Future<User?> get currentUser async {
    bool isReady = await storage.ready;
    if (isReady) {
      final Map<String, dynamic>? result = await storage.getItem('user');
      if (result == null) return null;
      return User.fromMap(result);
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final User? user = await currentUser;

    // the user is considered logged
    // only when it has a subscription.
    return user?.subscription?.type != SubscriptionType.free;
  }

  Future signUp({
    required User user,
  }) async {
    var result = await _usersService.signUp(user: user);
    if (result is User) {
      _currentUser = result;
      await storage.setItem('user', _currentUser!.toMap());
      return result;
    }
    if (result is HttpError) throw result.message;
    throw Errors.generic;
  }

  Future logIn({
    required User user,
  }) async {
    var result = await _usersService.logIn(user: user);
    if (result is User) {
      _currentUser = result;
      await storage.setItem('user', _currentUser!.toMap());
      return result;
    }
    if (result is HttpError) throw result;
    throw Errors.generic;
  }

  Future<void> refreshUser() async {
    try {
      User? current = await currentUser;
      if (current == null) return;
      var resultUser = await _usersService.getById(id: current.id!);
      if (resultUser == null) throw Exception('user does not exist');
      _currentUser = resultUser;
      await storage.setItem('user', _currentUser!.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    await storage.deleteItem('user');
    _currentUser = null;
  }
}
