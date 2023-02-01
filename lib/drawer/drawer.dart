import 'package:flutter/material.dart';
import 'package:weather_forcast/drawer/drawer_tiles.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key? key,
  }) : super(key: key);
  // final String currentPage;

  static const double iconSize = 35;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomDrawerTiles(
                  icon: const Icon(Icons.home), title: "Home", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
