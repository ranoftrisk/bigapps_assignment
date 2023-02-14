import 'package:bigapps_assignment/models/user_display/user.dart';
import 'package:bigapps_assignment/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserPreviewCard extends StatelessWidget {
  const UserPreviewCard({Key? key, required this.user}) : super(key: key);

  final borderRadius = 10.0;
  final User user;
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(bor),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Styles.kCardBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black54.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(1, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: user.imageUrl,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.firstName,
                  style: Styles.kGridFirstName,
                ),
                Text(
                  user.lastName,
                  style: Styles.kGridLastName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
