import 'package:flutter/material.dart';
import 'package:dari_version_complete/homeScreen.dart';
import 'package:dari_version_complete/loginScreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            text: 'Home',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.person,
            text: 'Profile',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Profile information"),
              ));
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            text: 'Settings',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Settings clicked"),
              ));
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: 'Log Out',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, size: 24, color: Colors.blueAccent),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}
