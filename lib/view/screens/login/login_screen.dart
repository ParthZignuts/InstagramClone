import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../view.dart';
import '../../../core/core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  ///On Login Button Press
  void login() async {
    setState(() {
      _isLoading = true;
    });
    String result = await AuthMethods().loginUser(email: emailController.text, password: passController.text);
    setState(() {
      _isLoading = false;
    });

    if (result != 'Login Successfully') {
      // ignore: use_build_context_synchronously
      showSnackbar(result, context);
    } else {
      // ignore: use_build_context_synchronously
      context.go('/MainScreen');
      // ignore: use_build_context_synchronously
      showSnackbar('SignIn Successfully ', context);
    }
  }

  /// on signup button press
  void navigateToSignUp() {
    context.go('/SignUpScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              ///svg image
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: SvgPicture.asset('assets/images/ic_instagram.svg', color: mobileBackgroundColor, height: 64,),
              ),

              /// textfield input for username
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

              ///login button
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: InkWell(
                  onTap: () => login(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: senderMsgBubbleColor,
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
                            'Login',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: primaryColor),
                          ),
                  ),
                ),
              ),
              const Spacer(),

              ///to show don't have an account
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () => navigateToSignUp(),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold, color: senderMsgBubbleColor, fontSize: 16),
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
