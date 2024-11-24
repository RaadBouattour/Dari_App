import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.123.150:5000'; // ***** Dima Yetbaddel dima tf9doooo ***** ///////

  static Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    print("Retrieved token: $token"); // Debug

    if (token == null) {
      print("No token found. User is not logged in.");
      return false;
    }

    final url = Uri.parse('$baseUrl/auth/check-login');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Login status: ${data['isLoggedIn']}");
        return data['isLoggedIn'];
      } else {
        print("Unexpected status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error checking login status: $e");
    }
    return false;
  }


  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    print("Token saved: $token"); // Add this debug line
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }
}
