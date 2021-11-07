import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String thePageTitle;
  const TitleWidget({ Key key, @required this.thePageTitle }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
        bottom: 12.0,
      ),
      child: Text(
        thePageTitle,
        style: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}