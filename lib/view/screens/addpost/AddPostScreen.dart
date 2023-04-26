import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../../widget/widget.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Post to'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 75,
                  width: 75,
                  child: AspectRatio(
                    aspectRatio: 478 / 451,
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60'),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter)),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: const TextField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: secondaryColor),
                      hintText: 'Enter caption here...',
                      border: InputBorder.none,
                    ),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextButton(title: 'Tag People', onPressed: () {}),
                  CustomTextButton(title: 'Add location', onPressed: () {}),
                  CustomTextButton(title: 'Add music', onPressed: () {}),
                  CustomTextButton(title: 'Also post to', onPressed: () {}),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                'Advance settings',
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 18),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right),
              ),
            )
          ],
        ),
      ),
    );
  }
}
