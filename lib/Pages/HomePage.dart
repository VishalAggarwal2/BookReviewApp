import 'package:bookreviewapp/Pages/AllBookReview.dart';
import 'package:bookreviewapp/Pages/AllBooksNotInLibrary.dart';
import 'package:bookreviewapp/Pages/LikedBookReviews.dart';
import 'package:bookreviewapp/Pages/PastReview.dart';
import 'package:bookreviewapp/Resolvers/Auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Auth auth = Auth('vishalaggarwal270@gmail.com'); // Replace with the actual email
  Future<bool>? isInLibraryTeamFuture;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    setState(() {
      isInLibraryTeamFuture = auth.checkIfUserIsInLibraryTeam(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Review"),
      ),
      body: Center(
        child: FutureBuilder<bool>(
          future: isInLibraryTeamFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data == true) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Welcome To BookReview"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Allbookreview(),
                        ),
                      );
                    },
                    child: Text("All Book Review ..."),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LikedBookReviews(),
                        ),
                      );
                    },
                    child: Text("Liked Books ..."),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserBookReviews(),
                        ),
                      );
                    },
                    child: Text("My Book Review ..."),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print("User is in library team. Showing all books not in library...");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BooksNotInLibraryPage(),
                        ),
                      );
                    },
                    child: Text("All Books not in Library ..."),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print("User is in library team. Validating review...");
                      // Perform action for "Validate Review"
                    },
                    child: Text("Validate Review ..."),
                  ),
                ],
              );
            } else {

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Welcome To BookReview"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Allbookreview(),
                        ),
                      );
                    },
                    child: Text("All Book Review ..."),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LikedBookReviews(),
                        ),
                      );
                    },
                    child: Text("Liked Books ..."),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserBookReviews(),
                        ),
                      );
                    },
                    child: Text("My Book Review ..."),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
