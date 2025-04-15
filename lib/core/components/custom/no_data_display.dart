import 'package:flutter/material.dart';

import '../../utils/styles.dart';
class DisplayNoDataMessage extends StatelessWidget {
  final String? message;
  final IconData icon;
  const DisplayNoDataMessage({
    this.message,
    this.icon = Icons.info_outline, // Default icon
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // const BackWithIconBG(
          //   iconData: Icons.assignment, title: 'Requests',isHome: true,),
          const SizedBox(height: 120,),
          Icon(
            icon,
            size: 80,
            color: Colors.grey.shade400, // Subtle color
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'No Data Available',
            style: Styles.text18SemiBold.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
