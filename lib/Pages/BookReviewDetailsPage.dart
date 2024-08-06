import 'package:flutter/material.dart';

class BookReviewDetailsPage extends StatelessWidget {
  final Map<String, dynamic> review;

  BookReviewDetailsPage({required this.review});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(review['bookName']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                child: review['bookImageUrl'] != null
                    ? Image.network(
                  review['bookImageUrl'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey[700],
                        size: 100,
                      ),
                    );
                  },
                )
                    : Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[700],
                    size: 100,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['bookReview'],
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Reviewed by: ${review['user']['firstName']}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        'Email: ${review['user']['email']}',
                        style: TextStyle(fontSize: 14.0, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book Type: ${review['bookType']}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Reference Number: ${review['referenceNumber']}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Present at Library: ${review['presentAtLibrary'] ? 'Yes' : 'No'}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
