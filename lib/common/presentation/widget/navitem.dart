import 'package:flutter/material.dart';
import 'package:sblog/configs/theme/color.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? GeneralColors.bColor : Colors.grey,),
            Text(
              label,
              style: TextStyle(color: isSelected ? GeneralColors.bColor : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
