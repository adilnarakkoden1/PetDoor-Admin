import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_door_admin/Controllers/db_service.dart';


class AdminProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot> categories = [];
  StreamSubscription<QuerySnapshot>? _categorySubscription;

  //animals
  List<QueryDocumentSnapshot> animals = [];
  StreamSubscription<QuerySnapshot>? _animalSubscription;
  int totalCategories = 0;
  int totalAnimals = 0;
  AdminProvider() {
    getCategories();
    getAnimals();
  }

  void getCategories() {
    _categorySubscription?.cancel();
    _categorySubscription = DbService().readCategories().listen((snapshot) {
      categories = snapshot.docs;
      totalCategories = snapshot.docs.length;
      notifyListeners();
    });
  }

  void getAnimals() {
    _animalSubscription?.cancel();
    _animalSubscription = DbService().readAnimals().listen((snapshot) {
      animals = snapshot.docs;
      totalAnimals = snapshot.docs.length;
      notifyListeners();
    });
  }
}
