import 'package:flutter/material.dart';
import 'package:pet_door_admin/Controllers/authentication_service.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
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
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App icon or logo
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
                      radius: 50,
                    ),
                  ),
                  SizedBox(height: 40),
                  // Sign Up text
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Join as a Shelter Owner',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 50),
                  // Form fields
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // Email Field
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
                              value!.isEmpty ? 'Enter your email' : null,
                        ),
                        SizedBox(height: 20),
                        // Password Field
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
                              value!.isEmpty ? 'Enter your password' : null,
                        ),
                        SizedBox(height: 40),
                        // Sign Up Button
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              AuthService()
                                  .createAccountWithEmail(_emailController.text,
                                      _passwordController.text)
                                  .then((value) {
                                if (value == 'Account Created') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Account created Successfully')));
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
                              horizontal: 120,
                              vertical: 15,
                            ),
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 30),
                        // Already have an account option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
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
