import 'package:flutter/material.dart';
import 'package:pet_door_admin/widgets/appbar.dart';

class Donations extends StatelessWidget {
  const Donations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Donations',
      ),
    );
  }
}
