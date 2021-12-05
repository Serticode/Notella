import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Column(children: <Widget>[
          Expanded(
            flex: 3,
            child: Image.asset("images/noteTaker.png"),
          ),
          Expanded(
            flex: 1,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Notella.',
                  cursor: "|",
                  curve: Curves.bounceIn,
                  textStyle: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 45.0,
                    color: Color(0xFF616161),
                  ),
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 15),
              displayFullTextOnTap: true,
            ),
          )
        ]),
      ),
    );
  }
}
