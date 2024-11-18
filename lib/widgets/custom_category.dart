import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_door_admin/Provider/admin_provider.dart';

class CustomCategory extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;

  const CustomCategory({
    Key? key,
    required this.controller,
    this.label = 'Category',
    this.hintText = 'Select Category',
    this.icon = Icons.category_outlined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Select Category:"),
            content: SingleChildScrollView(
              child: Consumer<AdminProvider>(
                builder: (context, value, child) {
                  if (value.categories.isEmpty) {
                    return const Text('No categories available');
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.categories.length,
                    itemBuilder: (context, index) {
                      final category = value.categories[index];
                      return TextButton(
                        onPressed: () {
                          controller.text = category["name"];
                          Navigator.pop(context);
                        },
                        child: Text(
                          category["name"],
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
      child: TextFormField(
        controller: controller,
        validator: (value) => value!.isEmpty ? "This can't be empty." : null,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          filled: true,
          fillColor: Colors.deepPurple.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
