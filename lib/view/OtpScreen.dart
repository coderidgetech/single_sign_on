import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_sign_on/utils/apputil.dart';

import '../view_model/auth_view_model.dart';

class OTPScreen extends StatefulWidget {
  final Function(String token) onLoginPressed;
  final String username;

  OTPScreen({required this.username, required this.onLoginPressed});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    String username = widget.username;
    print("sdfc");
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please enter the OTP sent to your phone',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: otpController,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter OTP';
                  }
                  if (value.length != 6) {
                    // Assuming OTP is 6 digits long
                    return 'Please enter a valid 6-digit OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Trigger OTP submission
                    // TODO : Hit api here with otp
                    Map otpData = {
                      "tenant": "TT",
                      "username": widget.username,
                      "otp": otpController.text,
                      "device": "",
                      "app": "portal"
                    };
                    authViewModel.validateOtp(jsonEncode(otpData), context).then((token) {
                      print("object");
                      if (token != null) {
                        widget.onLoginPressed(token);

                        print("Token received: $token");
                      } else {
                        print("Token is null");
                      }
                    });
                  }
                },
                child: Text('Submit OTP'),
              ),
              if (authViewModel.loading)
                Center(
                  child: CircularProgressIndicator(),
                )

            ],
          ),
        ),
      ),
    );
  }
}
