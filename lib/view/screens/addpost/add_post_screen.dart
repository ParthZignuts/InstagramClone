import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../../proiders/user_provider.dart';
import '../../widget/widget.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _postFile;
  bool _isLoading = false;
  TextEditingController captionController = TextEditingController();

  /// to post image
  postImage(
    String uid,
    String userName,
    String profImage,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await FireStoreMethods().uploadPost(captionController.text, uid, userName, _postFile!, profImage);
      clearFile();
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showSnackbar(
          'Posted!',
          context,
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showSnackbar(res, context);
      }
    } catch (err) {
      print(err.toString());
      showSnackbar(err.toString(), context);
    }
  }

  /// for clearing the image show upload screen will be appear
  clearFile() {
    setState(() {
      _postFile = null;
    });
  }

  /// to select image from gallery
  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _postFile = file;
                });
              },
              child: const Text('Take Photo'),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _postFile = file;
                });
              },
              child: const Text('Choose from Gallery'),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    ///if image not selected then it show's for the select image other wise post screen
    return _postFile == null
        ? Center(
            child: IconButton(icon: const Icon(Icons.upload), onPressed: () => _selectImage(context)),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: () => clearFile(),
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Post to'),
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(userProvider.getUser.uid, userProvider.getUser.userName, userProvider.getUser.photoUrl),
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
                  _isLoading
                      ? const Padding(
                          padding: EdgeInsets.only(top: 2.0, bottom: 5.0),
                          child: LinearProgressIndicator(),
                        )
                      : const Padding(padding: EdgeInsets.only(top: 2.0, bottom: 5.0)),
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
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_postFile!), fit: BoxFit.fill, alignment: FractionalOffset.topCenter)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: TextField(
                          controller: captionController,
                          decoration: const InputDecoration(
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
