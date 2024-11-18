import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    this.automaticallyImplyLeading = true,
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          fontFamily: 'RobotoSlab',
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
