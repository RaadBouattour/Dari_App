import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.26.150:5000'; // Dima Yetbaddel dima tf9do

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
  /*static Future<List<dynamic>> fetchHouses() async {
    final response = await http.get(Uri.parse('$baseUrl/houses'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load houses');
    }
  }

  // Function to add a house
  static Future<void> addHouse(Map<String, dynamic> houseData) async {
    final url = Uri.parse('$baseUrl/houses'); // Replace '/houses' with your endpoint path if different

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your-auth-token', // Add your auth token if required
        },
        body: jsonEncode(houseData),
      );

      if (response.statusCode == 201) {
        print('House added successfully: ${response.body}');
      } else {
        print('Failed to add house: ${response.statusCode} ${response.body}');
        throw Exception('Failed to add house: ${response.body}');
      }
    } catch (error) {
      print('Error while adding house: $error');
      throw error;
    }
  }

  static Future<Map<String, dynamic>> createReservation({
    required String houseId,
    required String checkInDate,
    required String checkOutDate,
  }) async {
    final url = Uri.parse('$baseUrl/reservations/$houseId'); // Adjust the endpoint as needed

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your-auth-token', // Add your auth token if required
        },
        body: jsonEncode({
          'checkInDate': checkInDate,
          'checkOutDate': checkOutDate,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create reservation: ${response.body}');
      }
    } catch (error) {
      print('Error creating reservation: $error');
      throw error;
    }
  }
*/
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