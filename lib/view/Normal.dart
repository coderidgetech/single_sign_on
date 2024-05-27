import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:single_sign_on/utils/apputil.dart';

import '../view_model/auth_view_model.dart';

class Normal extends StatefulWidget {
  final Map<String, dynamic> mapJson;

  Normal({required this.mapJson});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<Normal> {
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    Map<String, dynamic> map = widget.mapJson;
    print("===============>>>-- : " + map.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Normal Activity'),
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
                  labelText: 'Normal',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Utils.flushBarErrorMessage("I am NOrmal activity", context);
                  if (_formKey.currentState!.validate()) {
                    // Trigger OTP submission
                  }
                },
                child: Text('Normal button'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
