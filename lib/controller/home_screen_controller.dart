import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreenController with ChangeNotifier {
  // collection reference
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');
}
