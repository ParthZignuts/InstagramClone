import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import '../../utils/colors.dart';

class MyExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const MyExpandableText({Key? key, required this.text, this.maxLines = 2}) : super(key: key);

  @override
  _MyExpandableTextState createState() => _MyExpandableTextState();
}

class _MyExpandableTextState extends State<MyExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpandableText(
              widget.text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              expandText: 'Show more',
              collapseText: 'Show less',
              maxLines: widget.maxLines,
              linkColor: Theme.of(context).primaryColor,
              linkEllipsis: true,
              onLinkTap:()=>setState(() => _isExpanded = false),


            ),
            if (_isExpanded)
              TextButton(
                onPressed: () => setState(() => _isExpanded = false),
                child: Text('Show less', style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
          ],
        );
      },
    );
  }
}
