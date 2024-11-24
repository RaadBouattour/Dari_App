import 'dart:convert';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.123.150:5000'; // Base URL

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

  // Fetch Users API with dynamic token retrieval
  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    final url = Uri.parse('$baseUrl/auth/getall');
    final token = await AuthService.getToken(); // Dynamically retrieve the token

    if (token == null) {
      throw Exception('No token found. Please log in again.');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data); // Parse response as a list
      } else {
        throw Exception('Failed to fetch users: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
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

  // Fetch all houses API
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
      final token = await AuthService.getToken(); // Get the token dynamically
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(houseData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add house: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding house: $e');
    }
  }

  // Reservation API
  static Future<Map<String, dynamic>> reserveHouse({
    required String houseId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    final url = Uri.parse('$baseUrl/hr/houses/$houseId/reservations');
    try {
      final token = await AuthService.getToken(); // Retrieve token dynamically
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Fetch all houses (alternative)
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
