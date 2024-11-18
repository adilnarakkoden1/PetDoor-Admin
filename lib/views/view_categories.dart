import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_door_admin/Controllers/storage.dart';
import 'package:pet_door_admin/Provider/admin_provider.dart';
import 'package:pet_door_admin/models/category_model.dart';
import 'package:pet_door_admin/widgets/appbar.dart';
import 'package:provider/provider.dart';
import '../Controllers/db_service.dart';

class ViewCategories extends StatefulWidget {
  const ViewCategories({super.key});

  @override
  State<ViewCategories> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<ViewCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Animal Management',
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<CategoryModel> categories =
              CategoryModel.fromJsonList(value.categories);

          if (value.categories.isEmpty) {
            return Center(
              child: Text(
                "No Categories Found",
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            );
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                          categories[index].image.isEmpty
                              ? "https://demofree.sirv.com/nope-not-here.jpg"
                              : categories[index].image,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    categories[index].name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Tap to edit or delete",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onTap: () {
                    _showOptionsDialog(context, categories[index]);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.edit_outlined, color: Colors.deepPurple),
                    onPressed: () {
                      _showModifyDialog(context, categories[index]);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModifyDialog(context, null);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("What do you want to do?"),
        content: Text("Delete action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteConfirmDialog(context, category.id);
            },
            child: Text("Delete Category"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showModifyDialog(context, category);
            },
            child: Text("Update Category"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, String categoryId) {
    showDialog(
      context: context,
      builder: (context) => AdditionalConfirm(
        contentText: "Are you sure you want to delete this category?",
        onYes: () {
          DbService().deleteCategory(docId: categoryId);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Category Deleted")),
          );
        },
        onNo: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showModifyDialog(BuildContext context, CategoryModel? category) {
    showDialog(
      context: context,
      builder: (context) => ModifyCategory(
        isUpdating: category != null,
        categoryId: category?.id ?? "",
        image: category?.image,
        name: category?.name,
      ),
    );
  }
}

//------------------------
class ModifyCategory extends StatefulWidget {
  final bool isUpdating;
  final String? name;
  final String categoryId;
  final String? image;

  const ModifyCategory({
    super.key,
    required this.isUpdating,
    this.name,
    required this.categoryId,
    this.image,
  });

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdating && widget.name != null) {
      categoryController.text = widget.name!;
      imageController.text = widget.image!;
    }
    super.initState();
  }

  Future<void> pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await Storage().uploadImage(image!.path, context);
      setState(() {
        if (res != null) {
          imageController.text = res;
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image uploaded successfully")));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          widget.isUpdating ? "Update Category" : "Add Category",
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: categoryController,
                validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                decoration: InputDecoration(
                  hintText: "Category Name",
                  labelText: "Category Name",
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (image == null && imageController.text.isNotEmpty)
                Container(
                  margin: EdgeInsets.all(20),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageController.text,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else if (image != null)
                Container(
                  margin: const EdgeInsets.all(20),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(image!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Pick Image"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: imageController,
                validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                decoration: InputDecoration(
                  hintText: "Image Link",
                  labelText: "Image Link",
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (widget.isUpdating) {
                  await DbService().updateCategory(
                      docId: widget.categoryId,
                      data: {
                        "name": categoryController.text.toLowerCase(),
                        "image": imageController.text
                      });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Category Updated"),
                  ));
                } else {
                  await DbService().createCategory(data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Category Added"),
                  ));
                }
                Navigator.pop(context);
              }
            },
            child: Text(widget.isUpdating ? "Update" : "Add")),
      ],
    );
  }
}

class AdditionalConfirm extends StatelessWidget {
  final String contentText;
  final VoidCallback onYes;
  final VoidCallback onNo;

  const AdditionalConfirm({
    Key? key,
    required this.contentText,
    required this.onYes,
    required this.onNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmation',
          style: TextStyle(color: Colors.deepPurple)),
      content: Text(contentText),
      actions: [
        TextButton(
          onPressed: onNo,
          child: const Text('No'),
        ),
        TextButton(
          onPressed: onYes,
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
