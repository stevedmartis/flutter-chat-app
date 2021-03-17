import 'package:chat/widgets/product_description.dart';
import 'package:chat/widgets/product_view.dart';
import 'package:flutter/material.dart';

class ShoesDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(children: [
            Hero(
                tag: 'shoes-1',
                child: Material(
                    type: MaterialType.transparency,
                    child: ShoesSizePreview(fullScreen: true))),
            Positioned(
              top: 0,
              child: FloatingActionButton(
                child: Icon(Icons.chevron_left, color: Colors.white, size: 10),
                onPressed: () => {Navigator.pop(context)},
                backgroundColor: Colors.transparent,
                elevation: 0,
                highlightElevation: 0,
              ),
            )
          ]),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ShoesDescriptionPage(
                    titile: 'Nike Air Max 720',
                    description:
                        "The Nike Air Max 720 goes bigger than ever before with Nike's taller Air unit yet, offering more air underfoot for unimaginable, all-day comfort. Has Air Max gone too far? We hope so.",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
