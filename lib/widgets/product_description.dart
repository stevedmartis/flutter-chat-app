import 'package:flutter/material.dart';

class ShoesDescriptionPage extends StatelessWidget {
  final String titile;
  final String description;

  ShoesDescriptionPage({this.titile, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(this.titile,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
          SizedBox(height: 10),
          Text(this.description,
              style: TextStyle(color: Colors.grey, height: 1.6)),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
