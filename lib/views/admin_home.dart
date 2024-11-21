import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pet_door_admin/Controllers/authentication_service.dart';
import 'package:pet_door_admin/Controllers/db_service.dart';
import 'package:pet_door_admin/Provider/admin_provider.dart';
import 'package:pet_door_admin/models/product_model.dart';
import 'package:pet_door_admin/views/orders.dart';
import 'package:pet_door_admin/views/view_categories.dart';
import 'package:pet_door_admin/widgets/alert_dialog.dart';
import 'package:pet_door_admin/widgets/appbar.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminHome(),
    const ViewCategories(),
    const OrdersPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ViewCategories()));
    } else if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AdminHome()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const OrdersPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        automaticallyImplyLeading: false,
        title: 'Admin Home',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  title: "Logout Confirmation",
                  content: "Are you sure you want to log out?",
                  cancelText: "Cancel",
                  continueText: "Continue",
                  onCancel: () {
                    Navigator.pop(context);
                  },
                  onContinue: () {
                    Navigator.pop(context);
                    AuthService().logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/login", (route) => false);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<AnimalModel> products =
              AnimalModel.fromJsonList(value.animals) as List<AnimalModel>;

          if (products.isEmpty) {
            return Center(child: Text("No Animals Found"));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Choose your option"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AdditionalConfirm(
                                                  contentText:
                                                      "Are you sure you want to delete this product?",
                                                  onYes: () {
                                                    DbService().deleteAnimals(
                                                        docId:
                                                            products[index].id);
                                                    Navigator.pop(context);
                                                  },
                                                  onNo: () {
                                                    Navigator.pop(context);
                                                  }));
                                    },
                                    child: const Text("Delete Product")),
                              ],
                            ));
                  },
                  onTap: () => Navigator.pushNamed(context, "",
                      arguments: products[index]),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                products[index].image,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  log(error.toString());
                                  return Icon(Icons.error);
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    products[index].name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "₹ ${products[index].amount.toString()}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          products[index]
                                              .category
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, "/view_product",
                                        arguments: products[index]);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title:
                                                  const Text("Delete Product"),
                                              content: const Text(
                                                  "Are you sure you want to delete this product?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      DbService().deleteAnimals(
                                                          docId: products[index]
                                                              .id);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Yes")),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("No")),
                                              ],
                                            ));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/addanimal");
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              label: 'Orders',
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
