import 'package:flutter/material.dart';

class CustomDrawerTiles extends StatelessWidget {
  final Widget icon;
  final String title;
  final Function? onTap;
  const CustomDrawerTiles(
      {super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        onTap: onTap as void Function()?,
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 8, 0),
          height: 50,
          child: Row(
            children: [
              icon,
              const Padding(padding: EdgeInsets.only(right: 20)),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  textScaleFactor: 1.5,
                  // overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
