import 'package:bookreviewapp/Pages/BookReviewForm.dart';
import 'package:bookreviewapp/Resolvers/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool showOtpBox = false; // State variable to control OTP box visibility
  String message = ''; // State variable for displaying messages
  late Auth auth;
  void sendOtp() async {
    try {
      print("otp send called");
      // Initialize Auth class with entered email
      auth = Auth(emailController.text.toString());

      // Call varifyAndSendOtp() and await its result
      bool status = await auth.verifyAndSendOtp();

      // Update UI based on status
      setState(() {
        if (status) {
          showOtpBox = true; // Show OTP box if status is true
          message = auth.message; // Display message from Auth class
        } else {
          showOtpBox = false; // Hide OTP box if status is false
          message = auth.message; // Display message from Auth class
        }
      });

    } catch (error) {
      print('Error sending OTP: $error');
    }
  }

  void verifyOtp() async {
    try {
      // Check if OTP entered matches with OTP received
      print(auth.otp.toString());
      print(otpController.text);
      if (otpController.text == auth.otp.toString()) {
        // Save userId in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', auth.userId);

        // Navigate to BookReviewForm page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Bookreviewform()),
        );

      } else {
        setState(() {
          message = 'Invalid OTP. Please try again.';
        });
      }
    } catch (error) {
      print('Error verifying OTP: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  sendOtp(); // Call sendOtp function on button press
                },
                child: Text('Send OTP'),
              ),
              SizedBox(height: 20),
              if (showOtpBox)
                Column(
                  children: [
                    TextField(
                      controller: otpController,
                      decoration: InputDecoration(
                        hintText: 'Enter OTP',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: verifyOtp, child: Text("Vefify Otp"))
                  ],
                ),
              if (message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: auth.status||false ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
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
