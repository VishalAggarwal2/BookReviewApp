import 'package:flutter/material.dart';
import 'package:bookreviewapp/Resolvers/BookReview.dart';

class BooksNotInLibraryPage extends StatefulWidget {
  @override
  _BooksNotInLibraryPageState createState() => _BooksNotInLibraryPageState();
}

class _BooksNotInLibraryPageState extends State<BooksNotInLibraryPage> {
  late Future<List<dynamic>> futureBooksNotInLibrary;
  final Bookreview bookreview = Bookreview();

  @override
  void initState() {
    super.initState();
    futureBooksNotInLibrary = bookreview.fetchBooksNotInLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books Not in Library"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureBooksNotInLibrary,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (book['bookImageUrl'] != null)
                          Image.network(
                            book['bookImageUrl'],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, size: 50);
                            },
                          ),
                        SizedBox(height: 8),
                        Text('Book Name: ${book['bookName']}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Description: ${book['bookDsc']}'),
                        Text('Book Type: ${book['bookType']}'),
                        Text('Reviewed By LC Member: ${book['bookReviewByLcMember']}'),
                        Text('Rejected: ${book['isRejected']}'),
                        Text('Present at Library: ${book['presentAtLibrary']}'),
                        Text('Validated: ${book['isValidated']}'),
                        Text('Reference Number: ${book['referenceNumber']}'),
                        Text('Like Count: ${book['likeCount']}'),
                        Text('Review ID: ${book['reviewId']}'),
                        Text('Review: ${book['bookReview']}'),
                        if (book['user'] != null) ...[
                          Text('User Name: ${book['user']['firstName']}'),
                          Text('User Email: ${book['user']['email']}'),
                          if (book['user']['imageUrl'] != null)
                            Image.network(
                              book['user']['imageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image, size: 50);
                              },
                            ),
                        ],
                      ],
                      
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
