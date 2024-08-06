import 'package:flutter/material.dart';
import 'package:bookreviewapp/Pages/BookReviewDetailsPage.dart';
import 'package:bookreviewapp/Resolvers/BookReview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBookReviews extends StatefulWidget {
  const UserBookReviews({Key? key}) : super(key: key);

  @override
  _UserBookReviewsState createState() => _UserBookReviewsState();
}

class _UserBookReviewsState extends State<UserBookReviews> {
  late Future<List<dynamic>> futureUserBookReviews;
  Bookreview bookreview = Bookreview();
  String? _userId;

  @override
  void initState() {
    super.initState();
    loadUserId(); // Load userId from shared preferences when widget initializes
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId');
      futureUserBookReviews = bookreview.fetchAllBookReviewsByUserId(_userId ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        title: Text("Book Reviews by User"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureUserBookReviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No book reviews found for this user.'));
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
                        builder: (context) => BookReviewDetailsPage(review: review),
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
