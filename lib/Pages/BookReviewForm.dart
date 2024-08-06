import 'package:bookreviewapp/Pages/AllBookReview.dart';
import 'package:bookreviewapp/Pages/PastReview.dart';
import 'package:bookreviewapp/Resolvers/BookReview.dart';
import 'package:flutter/material.dart';

class Bookreviewform extends StatefulWidget {
  @override
  _BookReviewFormState createState() => _BookReviewFormState();
}

class _BookReviewFormState extends State<Bookreviewform> {
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _bookDescriptionController = TextEditingController();
  TextEditingController _bookImageController = TextEditingController();
  String _selectedBookType = 'Novel'; // Default value
  bool _presentAtLibrary = false;
  TextEditingController _bookReferenceNumberController = TextEditingController();
  TextEditingController _bookReviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with submission
      bool reviewAdded = await Bookreview().addBookReview(
        bookName: _bookNameController.text,
        bookDescription: _bookDescriptionController.text,
        bookType: _selectedBookType,
        bookReview: _bookReviewController.text,
        bookImageUrl: _bookImageController.text,
        presentAtLibrary: _presentAtLibrary,
        referenceNumber: _presentAtLibrary ? _bookReferenceNumberController.text : null,
      );

      // Show message based on reviewAdded status
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(reviewAdded ? 'Success' : 'Failed'),
          content: Text(reviewAdded ? 'Book review added successfully!' : 'Failed to add book review.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );

      // Optionally navigate to Allbookreview page on success
      if (reviewAdded) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserBookReviews()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Review Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Allbookreview()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _bookNameController,
                decoration: InputDecoration(
                  labelText: 'Book Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _bookDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Book Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _bookImageController,
                decoration: InputDecoration(
                  labelText: 'Book Image URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book image URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedBookType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedBookType = newValue!;
                  });
                },
                items: <String>[
                  'CSE',
                  'MME',
                  'Maths',
                  'CCE',
                  'ECE',
                  'Physics',
                  'Novel',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Book Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Present at Library:'),
                  SizedBox(width: 8.0),
                  Checkbox(
                    value: _presentAtLibrary,
                    onChanged: (newValue) {
                      setState(() {
                        _presentAtLibrary = newValue!;
                      });
                    },
                  ),
                ],
              ),
              if (_presentAtLibrary) ...[
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _bookReferenceNumberController,
                  decoration: InputDecoration(
                    labelText: 'Book Reference Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter book reference number';
                    }
                    return null;
                  },
                ),
              ],
              SizedBox(height: 16.0),
              TextFormField(
                controller: _bookReviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Book Review (50 Words Max)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book review';
                  }
                  if (value.trim().split(' ').length > 50) {
                    return 'Book review cannot exceed 50 words';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
