import 'package:flutter/material.dart';
import 'package:open/components/friend_post_title.dart';
import 'package:open/model/models.dart';
import 'package:open/theme/fooderlich_theme.dart';

class FriendPostListView extends StatelessWidget {
  final List<Post> friendPost;

  const FriendPostListView({Key? key, required this.friendPost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Social Chefs 👩‍🍳',
              style: FooderlichTheme.darkTextTheme.headline1),
          const SizedBox(height: 16),
          ListView.separated(
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return FriendPostTile(post: friendPost[index]);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
              itemCount: friendPost.length),
          // 6
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
