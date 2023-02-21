import 'dart:convert';
import 'package:mpg_mobile/constants/environments.dart';
import 'package:mpg_mobile/models/http_error.dart';
import 'package:mpg_mobile/models/user.dart';

import 'api.dart';

class UsersService extends Api {
  UsersService({required Environments environment})
      : super(environment: environment);

  Future<Object?> signUp({required User user}) async {
    var url = Uri.parse(getEndpoint() + ApiRoutes.signUp);
    var response = await client.post(
      url,
      body: json.encode(user.toMap()),
      headers: headers,
    );

    bool hasErrors = response.statusCode >= 400;
    if (hasErrors) return HttpError.fromMap(jsonDecode(response.body));
    return User.fromMap(jsonDecode(response.body));
  }

  Future<Object?> logIn({required User user}) async {
    var url = Uri.parse(getEndpoint() + ApiRoutes.logIn);
    var response = await client.post(
      url,
      body: json.encode(user.toMap()),
      headers: headers,
    );
    bool hasErrors = response.statusCode >= 400;
   
    if (hasErrors) return HttpError.fromMap(jsonDecode(response.body));
    return User.fromMap(jsonDecode(response.body));
  }

  Future<User?> resetPassword({required User user}) async {
    var url = Uri.parse(getEndpoint() + ApiRoutes.users + '/resetPassword');
    var response = await client.post(
      url,
      body: json.encode(user.toMap()),
      headers: headers,
    );
    bool hasErrors = response.statusCode >= 400;
    if (hasErrors) throw HttpError.fromMap(jsonDecode(response.body));
    return User.fromMap(jsonDecode(response.body));
  }

  Future<User?> getById({required int id}) async {
    var url = Uri.parse(getEndpoint() + ApiRoutes.users + '/$id');
    var response = await client.get(
      url,
      headers: headers,
    );
    return User.fromMap(jsonDecode(response.body));
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    var url = Uri.parse(getEndpoint() + ApiRoutes.users + '/resetPass/$email');
    var response = await client.post(
      url,
      headers: headers,
    );
    if (response.statusCode >= 400) {
      throw HttpError.fromMap(jsonDecode(response.body));
    }
  }

  Future<User> fetchUserByToken({required String? token}) async {
    var url = Uri.parse(getEndpoint() + ApiRoutes.users + '/token/$token');
    var response = await client.get(
      url,
      headers: headers,
    );
    if (response.statusCode >= 400) {
      throw HttpError.fromMap(jsonDecode(response.body));
    }

    return User.fromMap(jsonDecode(response.body));
  }
}
