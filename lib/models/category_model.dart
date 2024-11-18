import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;
  String image;

  CategoryModel({required this.id, required this.name, required this.image});

  factory CategoryModel.fromJson(Map<String, dynamic> json, String id) {
    return CategoryModel(
        id: id ?? "", name: json["name"] ?? "", image: json["image"]);
  }

  static List<CategoryModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) =>
            CategoryModel.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
//===========================================================================================================


