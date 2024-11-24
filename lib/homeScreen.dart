import 'package:dari_version_complete/addHomeScreen.dart';
import 'package:dari_version_complete/allHousesScreen.dart';
import 'package:dari_version_complete/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:dari_version_complete/api_service.dart';
import 'SignUpScreen.dart';
import 'reservationScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isLoading = true;
  List<Map<String, dynamic>> recommendations = [];
  List<Map<String, dynamic>> exclusiveHouses = [];

  @override
  void initState() {
    super.initState();
    fetchHousesFromApi();
  }

  Future<void> fetchHousesFromApi() async {
    try {
      final data = await ApiService.fetchHouses();
      setState(() {
        recommendations = data.take(5).toList();
        exclusiveHouses = data.skip(5).take(5).toList();
        isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching houses: $error')),
      );
    }
  }

  void filterHomes(String query) {
    setState(() {
      query = query.toLowerCase();
      recommendations = recommendations.where((home) {
        return home['title'].toLowerCase().contains(query) || home['location'].toLowerCase().contains(query);
      }).toList();

      exclusiveHouses = exclusiveHouses.where((home) {
        return home['title'].toLowerCase().contains(query) || home['location'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => AllHousesScreen()));
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(174, 159, 237, 251),
              const Color.fromARGB(218, 79, 214, 251),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _buildSearchBar(),
                  SizedBox(height: 20),
                  _buildSection(context, title: "Recommendations", homes: recommendations),
                  SizedBox(height: 20),
                  _buildSection(context, title: "Exclusive Houses", homes: exclusiveHouses),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 5, blurRadius: 15),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 101, 25, 25),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: const Color.fromARGB(255, 141, 139, 139),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          selectedFontSize: 15.0,
          unselectedFontSize: 15.0,
          iconSize: 25.0,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        onChanged: filterHomes,
        decoration: InputDecoration(
          hintText: 'Search for a home',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey),
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
                            builder: (context) => ReservationScreen(houseId: house['_id']),
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


  Widget _buildSection(BuildContext context, {required String title, required List<dynamic> homes}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homes.length,
            itemBuilder: (context, index) {
              final home = homes[index];
              return GestureDetector(
                onTap: () => _showHouseDetails(context, home), // Call modal directly
                child: Container(
                  width: 160,
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, spreadRadius: 5, offset: Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          home['images'].isNotEmpty ? home['images'][0] : 'https://via.placeholder.com/150',
                          height: 120,
                          width: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(home['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.location_on_sharp, size: 16),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(home['location'], style: TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis, maxLines: 1),
                                ),
                              ],
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
    );
  }
}
