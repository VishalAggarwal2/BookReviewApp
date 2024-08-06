import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth {
  String userId = '';
  int otp = 0;
  String message = '';
  String email;
  bool status = false;

  Auth(this.email);

  Future<bool> verifyAndSendOtp() async {
    try {
      var variables = {'email': email};

      var query = '''
        query SendOtp(\$email: String) {
          sendOtp(email: \$email) {
            message
            otp
            status
            userId
          }
        }
      ''';

      var response = await http.post(
        Uri.parse('http://localhost:8000/graphql'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query, 'variables': variables}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        var data = jsonResponse['data']['sendOtp'];
        message = data['message'];
        otp = data['otp'];
        status = data['status'];
        userId = data['userId'];

        return status;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (error) {
      print('Error sending OTP: $error');
      return false;
    }
  }


  Future<bool> checkIfUserIsInLibraryTeam(String userId) async {
    try {
      var query = '''
        query Query(\$userId: String) {
          isInLibraryTeam(userId: \$userId)
        }
      ''';
      var variables = {'userId': userId};

      var response = await http.post(
        Uri.parse('http://localhost:8000/graphql'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query, 'variables': variables}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse['data']['isInLibraryTeam'];
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (error) {
      print('Error checking user in library team: $error');
      return false;
    }
  }
}
