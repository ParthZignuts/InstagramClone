import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/core/controller/search_user_controller.dart';
import '../../view.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  static final SearchUserController _searchUserController = Get.put(SearchUserController());
  ValueNotifier<bool> update=ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: scaffoldBackgroundColor,
          elevation: 0,
          title: SizedBox(
            height: 40,
            child: TextFormField(
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.start,
              controller: _searchUserController.searchController.value,
              decoration: const InputDecoration(
                hintText: 'Search users...',
                contentPadding: EdgeInsets.only(bottom: 20),
                prefixIcon: Icon(
                  Icons.search,
                  color: darkGray,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: darkGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: darkGray),
                ),
              ),
              onFieldSubmitted: (_) {
                update.value=true;


              },
            ),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: update,
          builder: (context,val,child){
            return val? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                'userName',
                isGreaterThanOrEqualTo: _searchUserController.searchController.value.text,
              )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snapshot.connectionState==ConnectionState.waiting){
                  update.value=false;
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => context.push('/SearchedUser/${(snapshot.data! as dynamic).docs[index]['uid']}'),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]['photoUrl'],
                            ),
                            radius: 28,
                          ),
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]['userName'],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
                : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').orderBy('datePublished').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  physics: const BouncingScrollPhysics(),
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => context.push('/PostDetailedView/${(snapshot.data! as dynamic).docs[index]['postId']}'),
                    child: Image.network(
                      (snapshot.data! as dynamic).docs[index]['photoUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  staggeredTileBuilder: (index) => MediaQuery.of(context).size.width > webScreenSize
                      ? StaggeredTile.count((index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count((index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            );
          },
        ));
  }
}
