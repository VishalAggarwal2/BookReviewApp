import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Bookreview {
  Future<List<dynamic>> fetchAllBookReviews() async {
    const String url = 'http://localhost:8000/graphql';
    const String query = '''
      query AllBookReview {
        allBookReview {
          bookDsc
          bookImageUrl
          bookName
          bookReviewByLcMember
          bookType
          isRejected
          presentAtLibrary
          isValidated
          referenceNumber
          likeCount
          reviewId
          bookReview
          user {
            firstName
            email
            imageUrl
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['allBookReview'];
    } else {
      return [];
    }
  }

  Future<List<dynamic>> fetchBookReviewsLikedByUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? ''; // Replace with your key for userId

    const String url = 'http://localhost:8000/graphql';
    const String query = '''
      query GetBookReviewsLikedByUser(\$userId: String) {
        getBookReviewsLikedByUser(userId: \$userId) {
          bookDsc
          bookImageUrl
          bookName
          bookReviewByLcMember
          bookType
          isRejected
          presentAtLibrary
          isValidated
          referenceNumber
          likeCount
          reviewId
          bookReview
          user {
            firstName
            email
            imageUrl
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query, 'variables': {'userId': userId}}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['getBookReviewsLikedByUser'];
    } else {
      return [];
    }
  }

  Future<bool> addBookReview({
    required String bookName,
    required String bookDescription,
    required String bookType,
    required String bookReview,
    String? bookImageUrl,
    bool presentAtLibrary = false,
    String? referenceNumber,
  }) async {
    print("called");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? ''; // Replace with your key for userId

    const String url = 'http://localhost:8000/graphql';
    const String query = '''
      query AddBookReview(\$bookReviewInput: BookReviewInput!) {
        addBookReview(bookReviewInput: \$bookReviewInput)
      }
    ''';

    final Map<String, dynamic> variables = {
      'bookReviewInput': {
        'bookName': bookName,
        'bookDsc': bookDescription,
        'bookType': bookType,
        'bookReview': bookReview,
        'bookImageUrl': bookImageUrl,
        'presentAtLibrary': presentAtLibrary,
        'referenceNumber': referenceNumber,
        'userId': userId,
      }
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query, 'variables': variables}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String result = data['data']['addBookReview'];
      // Assuming your GraphQL server returns a success message upon addition
      if (result == 'Book review added successfully') {
        // Show a confirmation message
        print('Book review added successfully!');
        return true;
      } else {
        // Handle failure case
        print('Failed to add book review.');
        return false;
      }
    } else {
      // Handle HTTP error
      print('HTTP Error: ${response.statusCode}');
      return false;
    }
  }

  Future<List<dynamic>> fetchAllBookReviewsByUserId(String userId) async {
    const String url = 'http://localhost:8000/graphql';
    const String query = '''
    query AllBookReviewByUserId(\$userId: String!) {
      allBookReviewByUserId(userId: \$userId) {
        bookDsc
        bookImageUrl
        bookName
        bookReviewByLcMember
        bookType
        isRejected
        presentAtLibrary
        isValidated
        referenceNumber
        likeCount
        reviewId
        bookReview
        user {
          firstName
          email
          imageUrl
        }
      }
    }
  ''';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query, 'variables': {'userId': userId}}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['allBookReviewByUserId'];
    } else {
      return [];
    }
  }

  Future<List<dynamic>> fetchBooksNotInLibrary() async {
    const String url = 'http://localhost:8000/graphql';
    const String query = '''
      query NotInLibrary {
        NotInLibrary {
          bookDsc
          bookImageUrl
          bookName
          bookReviewByLcMember
          bookType
          isRejected
          presentAtLibrary
          isValidated
          referenceNumber
          likeCount
          reviewId
          bookReview
          user {
            firstName
            email
            imageUrl
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['NotInLibrary'];
    } else {
      return [];
    }
  }

}
