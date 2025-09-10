import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback onDownloadPressed;

  const AppHeader({
    Key? key,
    required this.onDownloadPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF7B68EE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.rocket_launch,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Hackletes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onDownloadPressed,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}