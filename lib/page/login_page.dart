import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sports_hub_ios/controllers/auth_controller.dart';
import 'package:sports_hub_ios/cubit/auth_cubit.dart';
import 'package:sports_hub_ios/page/reset_password_page.dart';
import 'package:sports_hub_ios/page/signup_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Global boolean to track loading state during login
bool isLoading = false;

class _LoginPageState extends State<LoginPage> {
  // Controllers for handling input from text fields
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive UI
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return MediaQuery(
      // Adjust text scaling to improve readability slightly
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.1)),
      child: Container(
        decoration: BoxDecoration(
          color: kBackgroundColor2,
          image: DecorationImage(
            // Background image for the login screen
            image: const AssetImage("assets/images/sports_background1.jpg"),
            fit: BoxFit.cover,
            // Apply a color filter to slightly dim the background image
            colorFilter: ColorFilter.mode(
                kBackgroundColor2.withOpacity(0.3), BlendMode.dstATop),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors
              .transparent, // Make scaffold transparent to show background
          // BlocConsumer listens to AuthCubit state changes and builds UI accordingly
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              // Handle different authentication states to navigate or show errors
              if (state is AuthAuthenticated) {
                // On successful authentication, navigate to home page
                context.go('/home');
              } else if (state is AuthError) {
                // On authentication error, show a Snackbar with the error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                // While authentication is in progress, show a loading spinner centered
                return Center(child: CircularProgressIndicator());
              }

              // Main UI stack containing the login form positioned at the bottom
              return Stack(children: [
                Positioned(
                  bottom: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: w,
                      height: h > 700 ? h * 0.70 : h * 0.85,
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      decoration: const BoxDecoration(
                        // Rounded top corners for the form container
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        color: Colors.white, // White background for form
                      ),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: h * 1.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: h * 0.04),

                              // Title text welcoming the user back
                              Text(
                                "WELCOME BACK",
                                style: TextStyle(
                                  fontSize: w > 385 ? 30 : 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: h * 0.02),

                              // Subtitle prompting the user to login
                              Text(
                                "Log into your account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: w > 385 ? 25 : 20,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: h * 0.06),

                              // Email input field container with decoration
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 7,
                                      offset: const Offset(1, 1),
                                      color: Colors.grey.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                child: TextFormField(
                                  controller: emailController,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w > 385 ? 16 : 13,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1.0),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  // Validate email input using the email_validator package
                                  validator: (email) => email != null &&
                                          !EmailValidator.validate(email)
                                      ? 'Please enter a valid email'
                                      : null,
                                ),
                              ),
                              SizedBox(height: h * 0.02),

                              // Empty container that might be placeholder for future input or spacing
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 7,
                                      offset: const Offset(1, 1),
                                      color: Colors.grey.withOpacity(0.2),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: h * 0.03),

                              // Password input field container with decoration
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 7,
                                      offset: const Offset(1, 1),
                                      color: Colors.grey.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true, // Hide password text
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w > 385 ? 16 : 13,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: const Icon(
                                      Icons.password_outlined,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1.0),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  // Validate password length (minimum 6 characters)
                                  validator: (value) => value != null &&
                                          value.length < 6
                                      ? 'Password must be at least 6 characters'
                                      : null,
                                ),
                              ),
                              SizedBox(height: 40),

                              // Login button with loading spinner while processing
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kBackgroundColor2,
                                  textStyle: const TextStyle(fontSize: 15),
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLoading =
                                        true; // Set loading state on press
                                  });

                                  // Trim input text to remove unnecessary spaces
                                  final String email =
                                      emailController.text.trim();
                                  final String password =
                                      passwordController.text.trim();

                                  // Access AuthCubit to handle login logic
                                  final cubit = context.read<AuthCubit>();

                                  // Trigger login event with email and password
                                  cubit.login(email, password, w);
                                },
                                child: isLoading
                                    ? Container(
                                        height: 25,
                                        width: 75,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(5),
                                        // Circular progress indicator during loading
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 25,
                                        width: 85,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "LOGIN",
                                          style: TextStyle(
                                            color: kBackgroundColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: w > 385 ? 12 : 10,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                              ),

                              const SizedBox(height: 15),

                              // Link for resetting password, navigates to ResetPasswordPage
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => ResetPasswordPage());
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: h * 0.01),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: kBackgroundColor2,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),

                              // Link to navigate to Signup page if user doesn't have an account
                              GestureDetector(
                                onTap: () {
                                  context.go('/signup');
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: h * 0.01),
                                  alignment: Alignment.center,
                                  child: RichText(
                                    text: const TextSpan(
                                      text: "Don't have an account?",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: " SIGN UP",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }
}
