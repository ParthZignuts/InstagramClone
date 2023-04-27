
import 'package:flutter/material.dart';

class UserStory extends StatelessWidget {
  const UserStory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.16,
      child: Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 20,
                  child: Column(
                    children: const [
                      CircleAvatar(
                        maxRadius: 35,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60'),
                      ),
                      Text('jenny_111'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
