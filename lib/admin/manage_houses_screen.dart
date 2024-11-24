import 'package:flutter/material.dart';
import 'package:dari_version_complete/api_service.dart';

class ManageHousesScreen extends StatefulWidget {
  @override
  _ManageHousesScreenState createState() => _ManageHousesScreenState();
}

class _ManageHousesScreenState extends State<ManageHousesScreen> {
  List<Map<String, dynamic>> _houses = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchHouses();
  }

  Future<void> _fetchHouses() async {
    try {
      final houses = await ApiService.fetchHouses();
      setState(() {
        _houses = houses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load houses: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Houses'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : ListView.builder(
        itemCount: _houses.length,
        itemBuilder: (context, index) {
          final house = _houses[index];
          return ListTile(
            title: Text(house['name'] ?? 'Unnamed House'),
            subtitle: Text(house['location'] ?? 'No location provided'),
          );
        },
      ),
    );
  }
}
