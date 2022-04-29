import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_ui_backend_clone/resources/auth_methods.dart';
import 'package:instagram_ui_backend_clone/utils/utils.dart';
import 'package:instagram_ui_backend_clone/widgets/web_text_field_input.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import 'package:instagram_ui_backend_clone/utils/dimensions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signupUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().SignUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    if (res != 'Success') {
      showSnackBar(res, context);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        );
      }));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MediaQuery.of(context).size.width < webScreenSize
            ? Container(
                padding: MediaQuery.of(context).size.width > webScreenSize
                    ? EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 3)
                    : EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                    //svg image
                    SvgPicture.asset(
                      'assets/images/ic_instagram.svg',
                      color: kPrimaryColor,
                      height: 64,
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    //Circular widget to accept and show our image
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    'https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1223671392?k=20&m=1223671392&s=170667a&w=0&h=kEAA35Eaz8k8A3qAGkuY8OZxpfvn9653gDjQwDHZGPE=')),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    //tect field input for username
                    TextFieldInput(
                        textEditingController: _usernameController,
                        textInputType: TextInputType.text,
                        hintText: "Enter your username"),
                    const SizedBox(
                      height: 24,
                    ),
                    //text field input for email
                    TextFieldInput(
                        textEditingController: _emailController,
                        textInputType: TextInputType.emailAddress,
                        hintText: "Enter your email"),
                    const SizedBox(
                      height: 24,
                    ),
                    // text field input for password
                    TextFieldInput(
                        textEditingController: _passwordController,
                        textInputType: TextInputType.text,
                        isPass: true,
                        hintText: "Enter your password"),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                        textEditingController: _bioController,
                        textInputType: TextInputType.text,
                        hintText: "Enter your bio"),
                    const SizedBox(
                      height: 24,
                    ),
                    //Signup button
                    InkWell(
                      onTap: signupUser,
                      child: Container(
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: kPrimaryColor,
                                ),
                              )
                            : const Text("Sign up"),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            color: kBlueColor),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                    //transitioning to signup
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text("Have an account?"),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Container(
                            child: const Text(
                              "Log in.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            :
            //Container for web!
            Container(
                color: const Color(0xfffafafa),
                child: ListView(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        width: MediaQuery.of(context).size.width / 5.0,
                        height: MediaQuery.of(context).size.height / 1.5,
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          border: Border.all(
                            color: const Color(0xffdbdbdb),
                            width: 1,
                          ),
                        ),
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(35, 45, 35, 10),
                          shrinkWrap: true,
                          children: [
                            Container(
                              height: 45,
                              width: (MediaQuery.of(context).size.width / 5.2) /
                                  1.8,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/loginheading.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Sign up to see photos and videos from your friends.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.facebookSquare,
                                      color: Colors.white,
                                      size: 17,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Log in with Facebook',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7,
                                ),
                                decoration: const ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  color: kBlueColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 1,
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                    width:
                                        MediaQuery.of(context).size.width / 10,
                                    color: const Color(0xffdbdbdb),
                                  ),
                                ),
                                const Text(
                                  'OR',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    height: 1,
                                    margin:
                                        const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    width:
                                        MediaQuery.of(context).size.width / 10,
                                    color: const Color(0xffdbdbdb),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            WebTextFieldInput(
                              emailController: _usernameController,
                              hintText: "Mobile number or email address",
                              textInputType: TextInputType.emailAddress,
                              obscureText: false,
                            ),
                            const SizedBox(height: 5),
                            WebTextFieldInput(
                              emailController: _bioController,
                              hintText: "Full name",
                              textInputType: TextInputType.name,
                              obscureText: false,
                            ),
                            const SizedBox(height: 5),
                            WebTextFieldInput(
                              emailController: _usernameController,
                              hintText: "Username",
                              textInputType: TextInputType.text,
                              obscureText: false,
                            ),
                            const SizedBox(height: 5),
                            WebTextFieldInput(
                              emailController: _passwordController,
                              hintText: "Password",
                              textInputType: TextInputType.visiblePassword,
                              obscureText: false,
                            ),
                            const SizedBox(height: 15),
                            InkWell(
                              onTap: signupUser,
                              child: Container(
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    color: kBlueColor),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'By signing up, you agree to our Terms, Data Policy and Cookie Policy.',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5.0,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xffdbdbdb),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: const Text(
                                "Have an account?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Container(
                                child: const Text(
                                  " Log in",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0095f7),
                                    fontSize: 12,
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 5.0,
                      alignment: Alignment.center,
                      child: const Text(
                        'Get the app.',
                        style: TextStyle(
                            color: kMobileBackgroundColor, fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 5.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://www.instagram.com/static/images/appstore-install-badges/badge_ios_english-en.png/180ae7a0bcf7.png',
                              height: 35,
                            ),
                            const SizedBox(width: 7),
                            Image.network(
                              'https://www.instagram.com/static/images/appstore-install-badges/badge_android_english-en.png/e9cd846dc748.png',
                              height: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
