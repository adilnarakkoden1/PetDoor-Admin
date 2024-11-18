import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_door_admin/Controllers/db_service.dart';
import 'package:pet_door_admin/Controllers/storage.dart';
import 'package:pet_door_admin/Provider/admin_provider.dart';
import 'package:pet_door_admin/models/product_model.dart';
import 'package:pet_door_admin/widgets/appbar.dart';
import 'package:pet_door_admin/widgets/customTextField.dart';
import 'package:provider/provider.dart';

class AddAnimals extends StatefulWidget {
  const AddAnimals({super.key});

  @override
  State<AddAnimals> createState() => _AddAnimalsState();
}

class _AddAnimalsState extends State<AddAnimals> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;

  final Widget space = SizedBox(height: 16);
  final formKey = GlobalKey<FormState>();
  late String productId = "";
  String? _imageError;

  String? selectedGender;
  final List<String> genderOptions = ["Male", "Female"];

  Future<void> pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await Storage().uploadImage(image!.path, context);
      setState(() {
        if (res != null) {
          _imageController.text = res;
          _imageError = null; // Clear error if image is selected
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image uploaded successfully")),
          );
        }
      });
    }
  }

  setData(AnimalModel data) {
    productId = data.id;
    _nameController.text = data.name;
    _breedController.text = data.breed;
    _ageController.text = data.age.toString();
    selectedGender = data.gender;
    _amountController.text = data.amount.toString();
    _categoryController.text = data.category;
    _descriptionController.text = data.description;
    _imageController.text = data.image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is AnimalModel) {
      setData(arguments);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Animal Management',
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade50, Colors.deepPurple.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: image != null
                        ? FileImage(File(image!.path))
                        : (_imageController.text.isNotEmpty
                            ? NetworkImage(_imageController.text)
                            : null) as ImageProvider?,
                    child: image == null && _imageController.text.isEmpty
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                    backgroundColor: Colors.white,
                  ),
                ),
                if (_imageError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _imageError!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                space,
                CustomTextField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.pets,
                ),
                space,
                CustomTextField(
                  controller: _breedController,
                  label: 'Breed',
                  icon: Icons.info_outline,
                ),
                space,
                TextFormField(
                  controller: _categoryController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Category",
                    labelText: "Category",
                    prefixIcon: Icon(Icons.category, color: Colors.deepPurple),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Select Category:"),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Consumer<AdminProvider>(
                                builder: (context, value, child) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: value.categories
                                      .map(
                                        (e) => TextButton(
                                          onPressed: () {
                                            _categoryController.text =
                                                e["name"];
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: Text(e["name"]),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                space,
                _buildGenderDropdown(),
                space,
                CustomTextField(
                  controller: _ageController,
                  label: 'Age',
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                ),
                space,
                CustomTextField(
                  controller: _amountController,
                  label: 'Amount',
                  icon: Icons.attach_money_outlined,
                  keyboardType: TextInputType.number,
                ),
                space,
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                space,
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (_imageController.text.isEmpty) {
                        setState(() {
                          _imageError = "Please select an image.";
                        });
                        return;
                      }
                      if (selectedGender == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please select a gender.")),
                        );
                        return;
                      }
                      Map<String, dynamic> data = {
                        "name": _nameController.text,
                        "breed": _breedController.text,
                        "age": int.parse(_ageController.text),
                        "amount": int.parse(_amountController.text),
                        "gender": selectedGender,
                        "category": _categoryController.text,
                        "desc": _descriptionController.text,
                        "image": _imageController.text,
                      };

                      if (productId.isNotEmpty) {
                        DbService().updateAnimals(docId: productId, data: data);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Product Updated")),
                        );
                      } else {
                        DbService().createAnimals(data: data);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Product Added")),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    productId.isNotEmpty ? "Update Product" : "Add Product",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: Icon(Icons.male, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      items: genderOptions
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedGender = value!;
        });
      },
      validator: (value) => value == null ? 'Please select a gender' : null,
    );
  }
}
