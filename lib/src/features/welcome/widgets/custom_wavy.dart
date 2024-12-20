import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class CustomWavyAnimatedText extends StatelessWidget {
  const CustomWavyAnimatedText({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayLarge!,
      child: AnimatedTextKit(
        totalRepeatCount: 100,
        animatedTexts: [
          WavyAnimatedText(
            text,
            textStyle: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}
