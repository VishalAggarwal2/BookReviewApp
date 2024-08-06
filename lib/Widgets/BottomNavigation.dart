import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookreviewapp/Pages/BookReviewForm.dart';
import 'package:bookreviewapp/Pages/HomePage.dart';
import 'package:bookreviewapp/Pages/LoginPage.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0; // Index for current selected tab
  late SharedPreferences _prefs;
  String? _userId; // Variable to store userId from shared preferences

  @override
  void initState() {
    super.initState();
    loadUserId(); // Load userId from shared preferences when widget initializes
  }

  Future<void> loadUserId() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = _prefs.getString('userId'); // Retrieve userId from shared preferences
    });
  }

  // Function to handle navigation bar item tap
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update current index of tab
    });
  }

  // Function to handle logout
  void _logout() async {
    await _prefs.remove('userId'); // Clear userId from shared preferences
    setState(() {
      _userId = null; // Clear userId in state
      _currentIndex = 0; // Navigate to home page after logout
    });
    // Navigate to login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? HomePage()
          : (_userId != null && _userId!.isNotEmpty ? Bookreviewform() : LoginScreen()), // Show current page based on index and login state
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Write Review',
          ),
          BottomNavigationBarItem(
            icon: _userId != null && _userId!.isNotEmpty
                ? Icon(Icons.logout)
                : Icon(Icons.login),
            label: _userId != null && _userId!.isNotEmpty ? 'Logout' : 'Login',

          ),



        ],
      ),
      appBar: AppBar(
        title: Text("Book Review"),
        actions: [
          if (_userId != null && _userId!.isNotEmpty)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
        ],
      ),
    );
  }
}
