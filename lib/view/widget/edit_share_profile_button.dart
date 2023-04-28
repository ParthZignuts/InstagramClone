
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class EditShareProfileButton extends StatelessWidget {
  const EditShareProfileButton({
    required this.btnTitle,
    required this.onPressed,
    super.key,
  });

  final String btnTitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      child: ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(darkGray),
          ),
          onPressed: onPressed,
          child: Text(
            btnTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          )),
    );
  }
}
