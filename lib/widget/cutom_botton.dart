import 'package:flutter/material.dart';

Widget labelwidget({
  required String labelText,
  required void Function()? onTap,
  Widget? child, 
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 60,
      width: 350,
      decoration: BoxDecoration(
        color: Colors.orange[800],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: child ?? Text( 
          labelText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}