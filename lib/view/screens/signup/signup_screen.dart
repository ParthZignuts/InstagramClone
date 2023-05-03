import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/view/screens/login/login_screen.dart';
import '../../../utils/colors.dart';
import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout.dart';
import '../../responsive/web_screen_layout.dart';
import '../../widget/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ///decalre texteditcontroller or local variable
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  Uint8List? imgFile;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
    bioController.dispose();
    usernameController.dispose();
  }

  ///to pick image from gallery
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      imgFile = im;
    });
  }

  ///SignUp Method
  void signUp() async {
    setState(() {
      _isLoading = true;
    });
    String result = await AuthMethods().signUpUser(
      email: emailController.text,
      password: passController.text,
      userName: usernameController.text,
      bio: bioController.text,
      file: imgFile!,
    );
    setState(() {
      _isLoading = false;
    });

    if (result != 'Success') {
      // ignore: use_build_context_synchronously
      showSnackbar(result, context);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      ));
      // ignore: use_build_context_synchronously
      showSnackbar('SignUp Successfully', context);
    }
  }

  ///navigate to loginpage
  void navigateToLoginPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              ///svg image
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: SvgPicture.asset('assets/images/ic_instagram.svg', color: primaryColor, height: 64),
              ),

              ///profile picture
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Stack(
                  children: [
                    imgFile != null
                        ? CircleAvatar(maxRadius: 60, backgroundImage: MemoryImage(imgFile!))
                        : const CircleAvatar(
                            maxRadius: 60,
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGUlMjBwaWN0dXJlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(onPressed: () => selectImage(), icon: const Icon(Icons.add_a_photo)))
                  ],
                ),
              ),

              /// textfield input for username
              TextFieldInput(
                  textEditingController: usernameController,
                  textInputType: TextInputType.text,
                  hintText: 'Enter Username',
                  isPass: false),

              /// textfield input for email
              TextFieldInput(
                  textEditingController: emailController,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Enter Email',
                  isPass: false),

              /// textfield input for password
              TextFieldInput(
                  textEditingController: passController,
                  textInputType: TextInputType.visiblePassword,
                  hintText: 'Enter Password',
                  isPass: true),

              /// textfield input for bio
              TextFieldInput(
                  textEditingController: bioController, textInputType: TextInputType.text, hintText: 'Enter Bio', isPass: false),

              /// signup button
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: InkWell(
                  onTap: () => signUp(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: blueColor,
                    ),
                    child: _isLoading
                        ? const Center(
                            child: SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                )))
                        : const Text(
                            'Signup',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                  ),
                ),
              ),
              const Spacer(),

              /// to show already have an account
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'I have an account? ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () => navigateToLoginPage(),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold, color: blueColor, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
