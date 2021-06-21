import 'package:flutter/material.dart';
import 'package:open/theme/fooderlich_theme.dart';

import 'circle_img.dart';

class AuthorCard extends StatefulWidget {
  final String author;
  final String title;

  final ImageProvider imageProvider;

  const AuthorCard(
      {Key? key,
      required this.title,
      required this.author,
      required this.imageProvider})
      : super(key: key);

  @override
  _AuthorCard createState() {
    return _AuthorCard();
  }
}

class _AuthorCard extends State<AuthorCard> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleImg(
                imageProvider: widget.imageProvider,
                imageRadius: 28,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.author,
                    style: FooderlichTheme.lightTextTheme.headline2,
                  ),
                  Text(
                    widget.title,
                    overflow: TextOverflow.clip,
                    style: FooderlichTheme.lightTextTheme.headline3,
                  ),
                ],
              ),
            ],
          ),
          IconButton(
              icon:  Icon(
                  _isFavorited ? Icons.favorite : Icons.favorite_border),
              iconSize: 30,
              color: Colors.red[400],
              onPressed: () {
                const snackBar = SnackBar(content: Text("press fav"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                setState(() {
                  _isFavorited = !_isFavorited;
                });
              })
        ],
      ),
    );
  }
}
