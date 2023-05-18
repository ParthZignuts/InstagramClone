import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import '../../view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        title: Form(
          child: SizedBox(
            height: 40,
            child: TextFormField(
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.start,
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search users...',
                contentPadding: EdgeInsets.only(bottom: 20),
                  prefixIcon: Icon(Icons.search,color: darkGray,),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: darkGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: darkGray),
                  ),
              ),
              onFieldSubmitted: (String _) {
                setState(() {
                  isShowUsers = true;
                });
                print(_);
              },
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'userName',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => context.push('/SearchedUser/${(snapshot.data! as dynamic).docs[index]['uid']}'),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['userName'],
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
                    onTap:() => context.push('/PostDetailedView/${(snapshot.data! as dynamic).docs[index]['postId']}'),
                    child: Image.network(
                      
                      (snapshot.data! as dynamic).docs[index]['photoUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                      .size
                      .width >
                      webScreenSize
                      ? StaggeredTile.count(
                      (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                      (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
