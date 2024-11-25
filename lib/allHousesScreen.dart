import 'package:flutter/material.dart';
import 'package:dari_version_complete/api_service.dart';
import 'package:dari_version_complete/addHomeScreen.dart';
import 'package:dari_version_complete/homeScreen.dart';
import 'package:dari_version_complete/loginScreen.dart';
import 'package:dari_version_complete/reservationScreen.dart';

import 'SignUpScreen.dart';

class AllHousesScreen extends StatefulWidget {
  @override
  _AllHousesScreenState createState() => _AllHousesScreenState();
}

class _AllHousesScreenState extends State<AllHousesScreen> {
  List<dynamic> houses = [];
  List<dynamic> filteredHouses = [];
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHouses();
  }

  Future<void> _fetchHouses() async {
    try {
      final fetchedHouses = await ApiService.fetchHouses();
      setState(() {
        houses = fetchedHouses;
        filteredHouses = fetchedHouses; // Initially display all houses
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load houses: $e')),
      );
    }
  }

  void filterHouses(String query) {
    setState(() {
      filteredHouses = houses.where((house) {
        final title = house['title']?.toLowerCase() ?? '';
        final location = house['location']?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return title.contains(searchLower) || location.contains(searchLower);
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 2:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sign In or Sign Up'),
              content: Text('Please choose an option:'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(), // Replace with your Sign In screen
                      ),
                    );
                  },
                  child: Text('Sign In'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(), // Replace with your Sign Up screen
                      ),
                    );
                  },
                  child: Text('Sign Up'),
                ),
              ],
            );
          },
        );
        break;

        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(144, 159, 237, 251),
                  Color.fromARGB(255, 67, 214, 255),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      onChanged: filterHouses,
                      decoration: InputDecoration(
                        hintText: 'Search for a home',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredHouses.length,
                    itemBuilder: (context, index) {
                      final house = filteredHouses[index];

                      return GestureDetector(
                        onTap: () {
                          _showHouseDetails(context, house);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  house['images']?[0] ??
                                      'https://via.placeholder.com/150',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      house['title'] ?? 'No title',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      house['location'] ?? 'No location',
                                      style: TextStyle(
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 15,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 143, 42, 42),
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: const Color.fromARGB(255, 141, 139, 139),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline), label: 'Add'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
            selectedFontSize: 15.0,
            unselectedFontSize: 15.0,
            iconSize: 25.0,
          ),
        ),
      ),
    );
  }

  void _showHouseDetails(BuildContext context, Map<String, dynamic> house) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 174, 218, 252),
                Color.fromARGB(255, 119, 185, 255),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main image
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    house['images'] != null && house['images'].isNotEmpty
                        ? house['images'][0]
                        : 'https://via.placeholder.com/300',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  house['title'] ?? 'No title',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Location and details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.black, size: 20),
                        SizedBox(width: 5),
                        Text(
                          house['location'] ?? 'No location',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.bed, color: Colors.black, size: 20),
                        SizedBox(width: 5),
                        Text(
                          '${house['rooms'] ?? 'N/A'} rooms',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.bathtub, color: Colors.black, size: 20),
                        SizedBox(width: 5),
                        Text(
                          '${house['bathrooms'] ?? 'N/A'} bathrooms',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  house['description'] ?? 'No description available',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              Spacer(),
              // Price and Reserve Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      house['pricePerMonth'] != null
                          ? '${house['pricePerMonth']} TND per month'
                          : 'No price available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReservationScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Reserve Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
