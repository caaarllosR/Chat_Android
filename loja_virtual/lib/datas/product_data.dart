import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {

  String  _id;
  String  _category;
  String  _title;
  String  _description;
  double  _price;
  List    _sizes;
  List    _images;

  String get id          => _id;
  String get category    => _category;
  String get title       => _title;
  String get description => _description;
  double get price       => _price;
  List   get sizes       => _sizes;
  List   get images      => _images;


  set category(String category) {_category = category;}

  ProductData.fromDocument(DocumentSnapshot snapshot){
    _id = snapshot.id;
    _title = snapshot.data()["title"];
    _description = snapshot.data()["description"];
    _price = snapshot.data()["price"];
    _images = snapshot.data()["images"];
    _sizes = snapshot.data()["sizes"];
  }

  Map<String, dynamic> toResumeMap() {
    return {
      "title": _title,
      "description": _description,
      "price": _price
    };
  }

}