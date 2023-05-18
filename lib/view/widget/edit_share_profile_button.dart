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
      width: MediaQuery.of(context).size.width * 0.35,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: mobileBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: onPressed,
          child: Text(
            btnTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )),
    );
  }
}
