import 'package:flutter/material.dart';

class CategoryItem {
  final IconData icon;
  final String title;
  bool isSelected;

  CategoryItem({
    required this.icon,
    required this.title,
    required this.isSelected,
  });
}