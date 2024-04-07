import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Color colour) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        height: 48,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: colour,
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
