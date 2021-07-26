import 'package:flutter/material.dart';
import 'package:vdo_player/screens/otp_verification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Welcome to videoplayer",
          ),
          backgroundColor: Colors.grey),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Text("Please enter your phone number to login",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.grey,
                hoverColor: Colors.green,
                focusColor: Colors.green,
                icon: Icon(
                  Icons.phone_android,
                  color: Colors.green,
                ),
                hintText: "phone number",
                prefix: Padding(
                  padding: EdgeInsets.all(4),
                  child: Text("+91"),
                ),
              ),
              maxLength: 10,
              keyboardType: TextInputType.number,
              controller: _controller,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OtpVerification(_controller.text)));
              },
              label: Text("Get OTP"),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
