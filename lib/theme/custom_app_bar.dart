import 'package:flutter/material.dart';

PreferredSizeWidget CustomAppBar(BuildContext context, String title) {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    elevation: 0,
    title: Text(
      title,
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
  );
}