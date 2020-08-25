import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  final String _type;
  final ProductData _productData;

  ProductTile(this._type, this._productData);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProductScreen(_productData))
        );
      },
        child: Card(
            child: _type == "grid"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 0.8,
                        child: Image.network(
                          _productData.images[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  _productData.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                    "R\$ ${_productData.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            )
                        ),
                      )
                    ],
                  )
                : Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Image.network(
                    _productData.images[0],
                    fit: BoxFit.cover,
                    height: 250.0,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _productData.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "R\$ ${_productData.price.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      )
                  ),
                )
              ],
            )
        )
    );
  }
}
