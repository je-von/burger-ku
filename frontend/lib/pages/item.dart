import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/util/api.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ItemPageState();
  }
}

class ItemPageState extends State<ItemPage> {
  List<dynamic> _items = [];

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  _getAllItems() async {
    final response = await Api.request('get', 'items');
    setState(() {
      if (response.statusCode == 200) {
        _items = json.decode(response.body)['data'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllItems();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: [Text('$_items')],
    );
  }
}
