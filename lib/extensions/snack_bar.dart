import 'package:flutter/material.dart';

class SnackBarr {
  static snackBar(String text) => SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        dismissDirection: DismissDirection.none,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(bottom: 15),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 130),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blueAccent,
            ),
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      );
}
