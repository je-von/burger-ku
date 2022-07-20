import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/item.dart';
import 'package:frontend/util/api.dart';
import 'package:frontend/util/helper.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  State<StatefulWidget> createState() {
    return DetailPageState();
  }
}

class DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Container(
            margin: const EdgeInsets.all(30),
            height: 200,
            width: 200,
            child: Center(
              child: Image.network(
                Api.backendUrl + widget.item.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            widget.item.name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.item.description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
          Text(
            NumberFormat.currency(locale: 'ID').format(widget.item.price),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () async {
              final response = await Api.request(
                'post',
                'carts',
                body: {'item_id': '${widget.item.id}'},
              );

              if (!mounted) return;
              if (response.statusCode == 200) {
                Helper.showSnackBar(
                    context, '${widget.item.name} added to cart successfully');
              } else {
                Helper.showSnackBar(
                    context, json.decode(response.body)['message']);
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.orange;
                }
                return Colors.orange.shade200;
              }),
            ),
            child: const Text(
              'ADD TO CART',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(title: Text(widget.item.name)),
    );
  }
}
