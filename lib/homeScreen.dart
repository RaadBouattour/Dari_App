/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_location/addHome.dart';
import 'package:home_location/allHousesScreen.dart';
import 'package:home_location/login.dart';
import 'package:home_location/reservationScreen.dart';
import 'package:home_location/signUpScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> recommendations = [
    {
      'iconLocation': Icons.location_on_sharp,
      'iconDescription': Icons.description,
      'title': 'S+1 Haut Standing',
      'location': 'Casba, Bensid City',
      'imageAsset': 'assets/home4.jpg',
      'price' :'200dt',
      'description': ' se compose d un salon lumineux avec accès à un balcon dune cuisine ouverte design et de deux chambres confortables',
    },
    {
      'iconLocation': Icons.location_on_sharp,
      'iconDescription': Icons.description,
      'title': 'S+2 Haut Standing',
      'location': 'Casba, Bensid City',
      'price' :'100dt',
      'imageAsset': 'assets/home1.jpg',
      'description': ' se compose d un salon lumineux avec accès à un balcon dune cuisine ouverte design et de deux chambres confortables',
    },
    {
      'iconLocation': Icons.location_on_sharp,
      'iconDescription': Icons.description,
      'title': 'S+4 Haut Standing',
      'location': 'Medina, Maison',
      'price' :'400dt',
      'imageAsset': 'assets/home2.jpg',
      'description': ' se compose d un salon lumineux avec accès à un balcon dune cuisine ouverte design et de deux chambres confortables',
    },
    {
      'iconLocation': Icons.location_on_sharp,
      'iconDescription': Icons.description,
      'title': 'S+2 Haut Standing',
      'location': 'Medina, Maison',
      'price' :'600dt',
      'imageAsset': 'assets/home3.jpg',
      'description': ' se compose d un salon lumineux avec accès à un balcon dune cuisine ouverte design et de deux chambres confortables',
    },
    {
      'iconLocation': Icons.location_on_sharp,
      'iconDescription': Icons.description,
      'title': 'S+3 Haut Standing',
      'location': 'Casba, Bensid City',
      'imageAsset': 'assets/home4.jpg',
      'price' :'800dt',
      'description': ' se compose d un salon lumineux avec accès à un balcon dune cuisine ouverte design et de deux chambres confortables',
    },
    // Autres maisons...
  ];


  final List<Map<String, dynamic>> exclusiveHouses = [
    {
      'iconLocation': Icons.location_on_sharp,
      'iconDescription': Icons.description,
      'title': 'S+2 Haut Standing',
      'location': 'Casba, Bensid City',
      'imageAsset': 'assets/home1.jpg',
      'description': ' se compose d un salon lumineux avec accès à un balcon dune cuisine ouverte design et de deux chambres confortables',
    },
    {
      'iconLocation': Icons.location_on_sharp,
      'iconDescription': Icons.description,
      'title': 'S+2 Haut Standing',
      'location': 'Medina, Maison',
      'price' :'150dt',
      'imageAsset': 'assets/home3.jpg',
      'description': ' se compose d un salon lumineux avec accès à un balcon dune cuisine ouverte design et de deux chambres confortables',
    },
    {
      'iconLocation': Icons.location_on_sharp,
      'iconDescription': Icons.description,
      'title': 'S+3 Haut Standing',
      'location': 'Casba, Bensid City',
      'imageAsset': 'assets/home4.jpg',
      'price' :'550dt',
      'description': ' se compose d un salon lumineux avec accès à un balcon dune cuisine ouverte design et de deux chambres confortables',
    },
    // Autres maisons...
  ];


  List<Map<String, dynamic>> filteredRecommendations = [];
  List<Map<String, dynamic>> filteredExclusiveHouses = [];

  @override
  void initState() {
    super.initState();
    filteredRecommendations = recommendations;
    filteredExclusiveHouses = exclusiveHouses;
  }

  void filterHomes(String query) {
    setState(() {
      query = query.toLowerCase();
      filteredRecommendations = recommendations.where((home) {
        return home['title']!.toLowerCase().contains(query) || home['location']!.toLowerCase().contains(query);
      }).toList();

      filteredExclusiveHouses = exclusiveHouses.where((home) {
        return home['title']!.toLowerCase().contains(query) || home['location']!.toLowerCase().contains(query);
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
        if (!isLoggedIn) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Expanded(child: Text("Tu ne peux pas ajouter une maison")),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                    },
                    child: Text("Sign Up", style: TextStyle(color: Colors.blue)),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: Text("Login", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
          );
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddHomeScreen()));
        }
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
    }
  }

  bool isLoggedIn = false;




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
            SystemNavigator.pop();
          },
        ),
      ),
      body: Container(
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
                  _buildSection(context, title: "Recommendation", homes: filteredRecommendations),
                  SizedBox(height: 20),
                  _buildSection(context, title: "Exclusive Houses", homes: filteredExclusiveHouses),
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
        decoration:
        InputDecoration(hintText: 'Search for a home', border: InputBorder.none, icon: Icon(Icons.search, color: Colors.grey)),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<dynamic> homes}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AllHousesScreen()));
              },
              child:
              Text('View All',
                  style: TextStyle(color: Color.fromARGB(255, 28, 132, 197))),
            ),
          ],
        ),
        SizedBox(height: 3),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homes.length,
            itemBuilder: (context, index) {
              final home = homes[index];
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.55,
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
                            // Image principale
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  home['imageAsset'] ?? 'assets/images/placeholder.png',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Titre
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                home['title'] ?? 'No title',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            // Détails (icônes + texte)
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
                                        home['location'] ?? 'No location',
                                        style: TextStyle(fontSize: 16, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.bed, color: Colors.black, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        '3 rooms',
                                        style: TextStyle(fontSize: 16, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.bathtub, color: Colors.black, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        '1 bathroom',
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
                                home['description'] ?? 'No description available',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ),
                            Spacer(),
                            // Bouton d'action (prix)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    home['price'] ?? 'No price available',
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
                                        MaterialPageRoute(builder: (context) => ReservationScreen()),
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
                },
                child: Container(
                  width: 160,
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius
                            .circular(15)),
                        child:
                        Image.asset(
                          home['imageAsset'] ?? 'assets/images/placeholder.png',
                          height: 120, width: 160, fit:
                        BoxFit.cover,),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(home['title'] ?? 'No title', style:
                            TextStyle(fontSize:
                            16, fontWeight:
                            FontWeight.bold),),
                            SizedBox(height:
                            5),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on_sharp, color:
                                Colors.black, size:
                                16),
                                SizedBox(width:
                                5),
                                Expanded(child:
                                Text(home['location'] ?? 'No location', style:
                                TextStyle(fontSize:
                                14, color:
                                Colors.black), overflow:
                                TextOverflow.ellipsis, maxLines:
                                1,),),
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
 */