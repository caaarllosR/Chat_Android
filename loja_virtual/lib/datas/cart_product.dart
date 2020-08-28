import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {

  String _cid;

  String _category;
  String get category => _category;


  String _pid;
  String get pid => _pid;


  int _quantity;

  int get quantity => _quantity;
  set quantity(int quantity) {
    _quantity = quantity;
  }


  String _size;
  String get size => _size;

  ProductData _productData;
  ProductData get productData => _productData;
  set productData(ProductData productData) {
    _productData = productData;
  }




  String get cid => _cid;

  set cid(String cid) {_cid = cid;}

  CartProduct({@required String size, @required int quantity, @required String pid, @required String category}){
    _size     = size;
    _quantity = quantity;
    _pid      = pid;
    _category = category;
  }

  CartProduct.fromDocument(DocumentSnapshot document){
    _cid      = document.id;
    _category = document.data()["category"];
    _pid      = document.data()["pid"];
    _quantity = document.data()["quantity"];
    _size     = document.data()["size"];
  }

  Map<String, dynamic> toMap() {
    return {
      "category": _category,
      "pid": _pid,
      "quantity": _quantity,
      "size": _size,
     // "product": _productData.toResumeMap()
    };
  }

}