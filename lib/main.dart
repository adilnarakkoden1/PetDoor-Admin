import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pet_door_admin/Controllers/authentication_service.dart';
import 'package:pet_door_admin/Provider/admin_provider.dart';
import 'package:pet_door_admin/firebase_options.dart';
import 'package:pet_door_admin/views/add_animals.dart';
import 'package:pet_door_admin/views/admin_home.dart';
import 'package:pet_door_admin/views/login_page.dart';
import 'package:pet_door_admin/views/orders.dart';
import 'package:pet_door_admin/views/register_page.dart';
import 'package:pet_door_admin/views/update_animals.dart';
import 'package:pet_door_admin/views/view_categories.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminProvider(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PetDoor Admin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: "/login",
        routes: {
          "/": (context) => LoginPage(),
          "/login": (context) => LoginPage(),
          "/signup": (context) => RegisterPage(),
          "/home": (context) => AdminHome(),
          "/addanimal": (context) => AddAnimals(),
          "/category": (context) => ViewCategories(),
          "/view_product": (context) => ModifyProduct(),
          "/orders": (context) => OrdersPage(),
          "/view_order": (context) => ViewOrder(),
        },
      ),
    );
  }
}

class UserLogged extends StatefulWidget {
  const UserLogged({super.key});

  @override
  State<UserLogged> createState() => _UserLoggedState();
}

class _UserLoggedState extends State<UserLogged> {
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
