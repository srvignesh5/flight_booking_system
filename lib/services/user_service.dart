import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'parse_config.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  String? _token; 

  Future<UserModel> loginUser(String username, String password) async {
  final url = '${ParseConfig.loginUrl}/login?username=$username&password=$password';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'X-Parse-Application-Id': ParseConfig.appId,
      'X-Parse-REST-API-Key': ParseConfig.apiKey,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data['sessionToken'] != null) {
      _token = data['sessionToken'];  
    } else {
      throw Exception('Session token not found in response.');
    }

    return UserModel.fromJson(data); 
  } else {
    throw Exception('Login failed. Please check your credentials.');
  }
}

Future<void> registerUser({
  required String fullName,
  required String email,
  required String password,
}) async {
  final url = '${ParseConfig.loginUrl}/users';

  final body = jsonEncode({
    'username': email,
    'password': password,
    'email': email,
    'fullName': fullName,
    'isAdmin': false,
  });

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'X-Parse-Application-Id': ParseConfig.appId,
      'X-Parse-REST-API-Key': ParseConfig.apiKey,
      'Content-Type': 'application/json',
    },
    body: body,
  );

  if (response.statusCode != 201) {
    final errorData = json.decode(response.body);
    throw Exception('Error: ${errorData['error']}');
  }
}

  String? get token => _token;
  bool get isLoggedIn => _token != null;

  void setToken(String? token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }
}
