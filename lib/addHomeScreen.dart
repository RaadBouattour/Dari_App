import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dari_version_complete/api_service.dart';
import 'package:dari_version_complete/allHousesScreen.dart';
import 'package:dari_version_complete/homeScreen.dart';
import 'package:dari_version_complete/loginScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddHomeScreen extends StatefulWidget {
  @override
  _AddHomeScreenState createState() => _AddHomeScreenState();
}

class _AddHomeScreenState extends State<AddHomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pricePerNightController = TextEditingController();
  final TextEditingController _pricePerMonthController = TextEditingController();
  final TextEditingController _surfaceController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _wcController = TextEditingController();

  static const String baseUrl = 'http://192.168.123.150:5000'; // Dima Yetbaddel dima tf9do


  File? _selectedImage;
  int _currentStep = 0;
  int _selectedIndex = 2;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      setState(() {
        _isLoggedIn = false;
      });
      return;
    }

    final url = Uri.parse('$baseUrl/auth/check-login'); //********************//
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoggedIn = true;
          _authToken = token; // Store the token for API calls
        });
      } else {
        setState(() {
          _isLoggedIn = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllHousesScreen()));
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        break;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_isLoggedIn) {
      _showLoginPrompt();
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez ajouter une image pour la propriété.')),
        );
        return;
      }

      final houseData = {
        'title': _titleController.text,
        'type': _typeController.text,
        'description': _descriptionController.text,
        'location': _addressController.text,
        'pricePerNight': double.tryParse(_pricePerNightController.text) ?? 0,
        'pricePerMonth': double.tryParse(_pricePerMonthController.text) ?? 0,
        'surface': double.tryParse(_surfaceController.text) ?? 0,
        'bedrooms': int.tryParse(_roomsController.text) ?? 0,
        'bathrooms': int.tryParse(_wcController.text) ?? 0,
        'images': [_selectedImage!.path],
        'isAvailable': true,
      };

      setState(() {
        _isLoading = true;
      });

      try {
        final url = Uri.parse('$baseUrl/houses/add');       ////***********//
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $_authToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(houseData),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maison ajoutée avec succès!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AllHousesScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Échec de l\'ajout de la maison: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Connexion requise"),
        content: const Text("Veuillez vous connecter avant d'ajouter une propriété."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: const Text("Se connecter"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Annuler"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une propriété"),
        backgroundColor: Colors.blue,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_formKey.currentState?.validate() ?? false) {
            if (_currentStep < 1) {
              setState(() {
                _currentStep++;
              });
            } else {
              _submitForm();
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        steps: [
          Step(
            title: const Text("Informations de base"),
            content: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Titre :", "Titre de la propriété", _titleController),
                  const SizedBox(height: 20),
                  _buildTextField("Type :", "Type de propriété", _typeController),
                  const SizedBox(height: 20),
                  _buildTextField("Description :", "Description de la propriété", _descriptionController),
                  const SizedBox(height: 20),
                  _buildTextField("Adresse :", "Adresse de la propriété", _addressController),
                  const SizedBox(height: 20),
                  _buildTextField("Prix par nuit :", "Prix en TND", _pricePerNightController),
                  const SizedBox(height: 20),
                  _buildTextField("Prix par mois :", "Prix en TND", _pricePerMonthController),
                  const SizedBox(height: 20),
                  _buildTextField("Surface :", "Surface en m²", _surfaceController),
                ],
              ),
            ),
          ),
          Step(
            title: const Text("Détails supplémentaires"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Chambres :", "Nombre de chambres", _roomsController),
                const SizedBox(height: 20),
                _buildTextField("Salles de bain :", "Nombre de salles de bain", _wcController),
                const SizedBox(height: 20),
                const Text(
                  "Ajouter une photo :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: _selectedImage == null
                        ? const Center(child: Text("Cliquez pour ajouter une image"))
                        : Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Rechercher'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Ajouter'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          validator: (value) => value?.isEmpty ?? true ? "Ce champ est obligatoire" : null,
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
