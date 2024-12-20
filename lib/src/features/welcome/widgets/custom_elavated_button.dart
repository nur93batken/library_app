import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.text,
    this.onPressed,
    super.key,
  });

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(double.maxFinite, 60),
        textStyle: Theme.of(context).textTheme.headlineMedium,
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }
}
