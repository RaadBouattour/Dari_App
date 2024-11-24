import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = 'http://192.168.100.135:5000'; // Dima Yetbaddel dima tf9do

  // Login API
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Parse the JSON response
    } else {
      throw Exception(jsonDecode(response.body)['message']); // Throw error message from backend
    }
  }

  // Register API
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Successful response
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body)['message'];
      throw Exception(error); // Backend error
    } else {
      throw Exception('An unexpected error occurred');
    }
  }






  // Fetch all houses
  static Future<List<Map<String, dynamic>>> fetchHouses() async {
    final url = Uri.parse('$baseUrl/houses/getall');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch houses: ${response.body}');
    }
  }




  // Method to add a house
  static Future<void> addHouse(Map<String, dynamic> houseData) async {
    final url = Uri.parse('$baseUrl/add');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(houseData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add house: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding house: $e');
    }
  }

  // Reservation

  static Future<Map<String, dynamic>> reserveHouse({
    required String houseId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    final url = Uri.parse('$baseUrl/houses/$houseId/reservations');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Add Authorization header if needed
          // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        },
        body: jsonEncode({
          'checkInDate': checkInDate.toIso8601String(),
          'checkOutDate': checkOutDate.toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': jsonDecode(response.body)['message']};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur : $e'};
    }
  }




  // get all houses

  static Future<List<dynamic>> fetchAllHouses() async {
    final url = Uri.parse('$baseUrl/getall');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return the list of houses
      } else {
        throw Exception('Failed to load houses');
      }
    } catch (e) {
      throw Exception('Error fetching houses: $e');
    }
  }

  // Database Connection Check API
  static Future<void> checkDatabaseConnection() async {
    final url = Uri.parse('$baseUrl/db/check-db');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("\x1B[32mDatabase connection successful: ${data['message']}\x1B[0m"); // Green text
    } else {
      print("\x1B[31mDatabase connection failed: ${response.body}\x1B[0m"); // Red text
    }
  }

}
