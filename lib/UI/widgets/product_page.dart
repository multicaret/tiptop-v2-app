import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/models/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage({@required this.product});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(product.title),
        leading: IconButton(
          icon: Icon(CupertinoIcons.clear_thick),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Text(product.title),
      ),
    );
  }
}
