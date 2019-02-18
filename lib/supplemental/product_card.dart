// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/app_state_model.dart';
import '../model/product.dart';
import '../colors.dart';

class ProductCard extends StatelessWidget {
  ProductCard({this.imageAspectRatio: 33 / 49, this.product})
      : assert(imageAspectRatio == null || imageAspectRatio > 0);

  final double imageAspectRatio;
  final Product product;
  var model;

  static final kTextBoxHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 0, locale: Localizations.localeOf(context).toString());
    final ThemeData theme = Theme.of(context);

    final imageWidget = Image.asset(
      product.assetName,
      package: product.assetPackage,
      fit: BoxFit.cover,
    );

    _openProductDetails() {
      return Navigator.push(context, MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Scaffold(
              backgroundColor: fColorOrange,
              appBar: AppBar(
                title: const Text('Product Details'),
                actions: <Widget>[],
              ),
              body: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      product.assetName,
                      package: product.assetPackage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300.00,
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 4.0),
                        Text(product.name, style: TextStyle(fontSize: 22.0)),
                        SizedBox(height: 4.0),
                        Text('Price : ${product.price}', style: TextStyle(fontSize: 18.0)),
                        SizedBox(height: 4.0),
                        Text('Description :${product.description}', style: TextStyle(fontSize: 16.0)),
                      ],
                    )
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 6.0),
                    child: RaisedButton(
                      color: fColorBackgroundWhite,
                      splashColor: fColorBrown900,
                      child: Text('Add To Cart', style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        model.addProductToCart(product.id);
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
          );
        },
        fullscreenDialog: true,
      ));
    }


    _setModel(child, model) {
      this.model = model;
      return GestureDetector(
        onTap: () => _openProductDetails(),
        child: child
      );
    }

    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => _setModel(child, model),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: imageAspectRatio,
                child: imageWidget,
              ),
              SizedBox(
                height: kTextBoxHeight * MediaQuery.of(context).textScaleFactor,
                width: 121.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      product == null ? '' : product.name,
                      style: theme.textTheme.button,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      product == null ? '' : formatter.format(product.price),
                      style: theme.textTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: new IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () => model.addProductToCart(product.id)
            )
          ),
        ],
      ),
    );
  }
}
