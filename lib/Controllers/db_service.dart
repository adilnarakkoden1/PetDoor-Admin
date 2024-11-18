import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  Stream<QuerySnapshot> readCategories() {
    return FirebaseFirestore.instance
        .collection("animal_categories")
        .snapshots();
  }

  Future createCategory({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("animal_categories").add(data);
  }

  Future updateCategory(
      {required String docId, required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance
        .collection("animal_categories")
        .doc(docId)
        .update(data);
  }

  Future deleteCategory({required String docId}) async {
    await FirebaseFirestore.instance
        .collection("animal_categories")
        .doc(docId)
        .delete();
  }

  // animal maangement

  Stream<QuerySnapshot> readAnimals() {
    return FirebaseFirestore.instance.collection("animal_list").snapshots();
  }

  Future createAnimals({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("animal_list").add(data);
  }

  Future updateAnimals(
      {required String docId, required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance
        .collection("animal_list")
        .doc(docId)
        .update(data);
  }

  Future deleteAnimals({required String docId}) async {
    await FirebaseFirestore.instance
        .collection("animal_list")
        .doc(docId)
        .delete();
  }


   // ORDERS
  // read all the orders
  Stream<QuerySnapshot> readOrders() {
    return FirebaseFirestore.instance
        .collection("shop_orders")
        .orderBy("created_at", descending: true)
        .snapshots();
  }

    // update the status of order
  Future updateOrderStatus(
      {required String docId, required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance
        .collection("shop_orders")
        .doc(docId)
        .update(data);
  }
}

