import 'package:application_principal/Blocks/side_bar.dart';
import 'package:flutter/material.dart';

class DrawerSideBar extends StatefulWidget {
  final String droit;
  final Color bgColor;
  const DrawerSideBar({Key? key, required this.droit, required this.bgColor})
      : super(key: key);

  @override
  State<DrawerSideBar> createState() => _DrawerSideBarState();
}

class _DrawerSideBarState extends State<DrawerSideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.bgColor,
      width: 250,
      child: SideBar(droit: widget.droit),
    );
  }
}
