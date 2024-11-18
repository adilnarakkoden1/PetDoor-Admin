import 'package:flutter/material.dart';
import 'package:pet_door_admin/Controllers/authentication_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    size.width > 600 ? size.width * 0.2 : 24, // Dynamic padding
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo or icon
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/3744410.jpg'),
                      radius: size.width > 600
                          ? 80
                          : 50, // Adjust size for larger screens
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  // Welcome text
                  Text(
                    'Welcome to PetDoor',
                    style: TextStyle(
                      fontSize: size.width > 600 ? 36 : 28, // Adjust font size
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Login as a Shelter Owner',
                    style: TextStyle(
                      fontSize: size.width > 600 ? 20 : 16, // Adjust font size
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            errorStyle: TextStyle(color: Colors.orange),
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: (value) =>
                              value!.isEmpty ? 'This field is required' : null,
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            errorStyle: TextStyle(color: Colors.orange),
                          ),
                          style: TextStyle(color: Colors.white),
                          validator: (value) =>
                              value!.isEmpty ? 'This field is required' : null,
                        ),
                        SizedBox(height: size.height * 0.04),
                        // Login Button
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              AuthService()
                                  .loginWithEmail(_emailController.text,
                                      _passwordController.text)
                                  .then((value) {
                                if (value == 'Login Successful') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Login Successful')));
                                  Navigator.restorablePushNamedAndRemoveUntil(
                                      context, '/home', (route) => false);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(value,
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.deepPurple,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width > 600 ? 140 : 120,
                              vertical: 15,
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: size.width > 600 ? 20 : 18,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
