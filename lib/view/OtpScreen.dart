import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../view_model/auth_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OTPScreen extends StatefulWidget {
  final Function(String token) onLoginPressed;
  final String username;
  final String baseUrl;
  final String deviceId;
  final String tenant;
  final String appName;

  OTPScreen({
    required this.username,
    required this.onLoginPressed,
    required this.baseUrl,
    required this.deviceId,
    required this.tenant,
    required this.appName,
  });

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String currentOtp = "";

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backg.png'),
                fit: BoxFit.fill, // Adjust as needed
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        SvgPicture.asset('assets/tectoro.svg'),
                        SizedBox(height: 10),
                        Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Please enter the OTP sent to your Mail',
                              style: TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 25.0),
                            PinCodeTextField(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              controller: otpController,
                              appContext: context,
                              length: 6,
                              // Assuming OTP is 6 digits long
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  currentOtp = value;
                                });
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length != 6) {
                                  return 'Please enter a valid 6-digit OTP';
                                }
                                return null;
                              },
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                                selectedColor: Colors.blue,
                                inactiveColor: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
// Trigger OTP submission
                                  Map otpData = {
                                    "tenant": widget.tenant,
                                    "username": widget.username,
                                    "otp": otpController.text,
                                    "device": widget.deviceId,
                                    "app": widget.appName,
                                  };
                                  try {
                                    final token =
                                        await authViewModel.validateOtp(
                                      jsonEncode(otpData),
                                      context,
                                      widget.baseUrl,
                                    );
                                    if (token != null && token.isNotEmpty) {
                                      widget.onLoginPressed(token);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('Invalid OTP')),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Error validating OTP')),
                                    );
                                  }
                                }
                              },
                              child: Text('Submit OTP'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff00BFC0),
                                // Background color
                                foregroundColor: Colors.white,
                                // Text color
                                elevation: 2,
                                // Elevation of the button
                                minimumSize: Size(double.maxFinite, 50),
                                // Width and height of the button
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                // Padding inside the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5), // Rounded corners
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  if (authViewModel.loading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
