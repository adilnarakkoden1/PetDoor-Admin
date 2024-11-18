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

class ModifyProduct extends StatefulWidget {
  const ModifyProduct({super.key});

  @override
  State<ModifyProduct> createState() => _ModifyProductState();
}

class _ModifyProductState extends State<ModifyProduct> {
  late String productId = "";
  final formKey = GlobalKey<FormState>();
  final Widget space = const SizedBox(height: 16);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;

  String? selectedGender;
  final List<String> genderOptions = ['Male', 'Female'];

  // ImagePicker
  Future<void> pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await Storage().uploadImage(image!.path, context);
      setState(() {
        if (res != null) {
          _imageController.text = res;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image uploaded successfully")),
          );
        }
      });
    }
  }

  // Set data from arguments
  void setData(AnimalModel data) {
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
      appBar: const CustomAppBar(
        title: 'Animal Management',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildImagePreview(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Pick Image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
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
                      validator: (v) =>
                          v!.isEmpty ? "This can't be empty." : null,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Category",
                        labelText: "Category",
                        prefixIcon:
                            const Icon(Icons.category, color: Colors.deepPurple),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                    const SizedBox(height: 15),
                    //_buildTextFormField(_imageController, "Image Link"),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Map<String, dynamic> data = {
                              "name": _nameController.text,
                              "breed": _breedController.text,
                              "category": _categoryController.text,
                              "gender": selectedGender,
                              "age": int.parse(_ageController.text),
                              "amount": int.parse(_amountController.text),
                              "desc": _descriptionController.text,
                              "image": _imageController.text,
                            };

                            if (productId.isNotEmpty) {
                              DbService()
                                  .updateAnimals(docId: productId, data: data);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Product Updated")),
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
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          productId.isNotEmpty
                              ? "Update Product"
                              : "Add Product",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return image == null
        ? _imageController.text.isNotEmpty
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(
                  _imageController.text,
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox()
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.file(
              File(image!.path),
              fit: BoxFit.cover,
            ),
          );
  }

  // Widget to build gender dropdown field
  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: genderOptions.contains(selectedGender) ? selectedGender : null,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: const Icon(Icons.male, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
          selectedGender = value;
        });
      },
      validator: (value) => value == null ? 'Please select a gender' : null,
    );
  }
}
