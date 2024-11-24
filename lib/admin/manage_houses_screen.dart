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

  Future<void> _deleteHouse(String houseId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await ApiService.deleteHouse(houseId); // Implement deleteHouse in your ApiService
      _fetchHouses(); // Refresh the list after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('House deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete house: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _viewHouseDetails(Map<String, dynamic> house) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(house['title'] ?? 'Unnamed House'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location: ${house['location'] ?? 'No location provided'}'),
              Text('Price: ${house['pricePerMonth'] ?? 'N/A'} \TND'),
              Text('Status: ${house['status'] ?? 'N/A'}'),
              Text('Description: ${house['description'] ?? 'No description'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Houses'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : ListView.builder(
        itemCount: _houses.length,
        itemBuilder: (context, index) {
          final house = _houses[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.blueAccent,
                size: 40,
              ),
              title: Text(
                house['title'] ?? 'Unnamed House',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(house['location'] ?? 'No location provided'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info, color: Colors.blueAccent),
                    onPressed: () => _viewHouseDetails(house),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteHouse(house['_id']); // Pass the house ID for deletion
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
