import 'package:bookreviewapp/Pages/BookReviewDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:bookreviewapp/Resolvers/BookReview.dart';

class Allbookreview extends StatefulWidget {
  @override
  State<Allbookreview> createState() => _AllbookreviewState();
}

class _AllbookreviewState extends State<Allbookreview> {
  late Future<List<dynamic>> futureBookReviews;
  Bookreview bookreview = Bookreview();

  @override
  void initState() {
    super.initState();
    futureBookReviews = bookreview.fetchAllBookReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Book Reviews ..."),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureBookReviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No book reviews found.'));
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
