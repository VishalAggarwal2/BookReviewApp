import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookreviewapp/Pages/BookReviewDetailsPage.dart';
import 'package:bookreviewapp/Resolvers/BookReview.dart';

class LikedBookReviews extends StatefulWidget {
  @override
  State<LikedBookReviews> createState() => _LikedBookReviewsState();
}

class _LikedBookReviewsState extends State<LikedBookReviews> {
  late Future<List<dynamic>> futureLikedBookReviews = Future.value([]);
  Bookreview bookreview = Bookreview();
  String? userId;

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    if (userId != null) {
      setState(() {
        futureLikedBookReviews = fetchLikedBookReviews(userId!);
      });
    } else {
      // User is not authenticated, show a message to login
      setState(() {
        futureLikedBookReviews = Future.value([]);
      });
    }
  }

  Future<List<dynamic>> fetchLikedBookReviews(String userId) async {
    try {
      return await bookreview.fetchBookReviewsLikedByUser();
    } catch (e) {
      print('Error fetching liked book reviews: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liked Book Reviews"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureLikedBookReviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return userId != null
                ? Center(child: Text('No liked book reviews found.'))
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Please login to access liked book reviews.'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to login page or handle login flow
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final review = snapshot.data![index];
                return ListTile(
                  leading: review['bookImageUrl'] != null
                      ? Image.network(
                    review['bookImageUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 50);
                    },
                  )
                      : Icon(Icons.book, size: 50),
                  title: Text(review['bookName']),
                  subtitle: Text(review['bookReview']),
                  isThreeLine: true,
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(review['user']['firstName']),
                      Text(review['user']['email']),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookReviewDetailsPage(review: review),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
