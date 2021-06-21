import 'package:flutter/material.dart';
import 'package:open/components/circle_img.dart';
import 'package:open/model/models.dart';
import 'package:open/theme/fooderlich_theme.dart';

class FriendPostTile extends StatelessWidget {
  final Post post;

  const FriendPostTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleImg(
          imageProvider: AssetImage(post.profileImageUrl ?? ""),
          imageRadius: 20,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.comment ?? ""),
            Text("${post.timestamp} mins ago",
                style: FooderlichTheme.darkTextTheme.bodyText1),
          ],
        ))
      ],
    );
  }
}
