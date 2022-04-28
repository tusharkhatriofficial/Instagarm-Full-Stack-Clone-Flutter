import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_ui_backend_clone/resources/auth_methods.dart';
import 'package:instagram_ui_backend_clone/utils/colors.dart';
import 'package:instagram_ui_backend_clone/utils/dimensions.dart';
import 'package:instagram_ui_backend_clone/utils/utils.dart';
import 'package:instagram_ui_backend_clone/widgets/text_field_input.dart';
import 'package:instagram_ui_backend_clone/widgets/web_text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'Success') {
      showSnackBar("Logged In", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        );
      }));
    } else {
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MediaQuery.of(context).size.width < webScreenSize
          ? kMobileBackgroundColor
          : Color(0xfffafafa),
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
                    //login button
                    InkWell(
                      onTap: loginUser,
                      child: Container(
                        child: const Text("Log in"),
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
                          child: Text("Don't have an account?"),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Container(
                            child: Text(
                              "Sign up.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            :
            //TODO this container is for web
            Container(
                margin: const EdgeInsets.only(
                    top: 50, left: 50, right: 50, bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      // height: MediaQuery.of(context).size.height / 1.45,
                      // width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 1,
                      width: MediaQuery.of(context).size.width / 3,
                      image: const AssetImage('assets/images/loginimage1.png'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      // height: MediaQuery.of(context).size.height / 1.7,
                      // width: MediaQuery.of(context).size.width / 5.00,
                      height: MediaQuery.of(context).size.height ,
                      width: MediaQuery.of(context).size.width / 4.00,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color(0xffdbdbdb),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(35, 45, 35, 10),
                            //below column is of signin form
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: (MediaQuery.of(context).size.width / 9),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/loginheading.png'),
                                      fit: BoxFit.fill
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 34,
                                ),
                                //text field input for email
                                WebTextFieldInput(
                                  emailController: _emailController,
                                  hintText:
                                      "Phone number, username or email address",
                                  textInputType: TextInputType.emailAddress,
                                  obscureText: false,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // text field input for password
                                WebTextFieldInput(
                                  emailController: _passwordController,
                                  hintText: "Password",
                                  textInputType: TextInputType.text,
                                  obscureText: true,
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                //login button
                                InkWell(
                                  onTap: loginUser,
                                  child: Container(
                                    child: const Text(
                                      "Log in",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        height: 1,
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 15, 0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                10,
                                        color: const Color(0xffdbdbdb),
                                      ),
                                    ),
                                    const Text(
                                      'OR',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        height: 1,
                                        margin: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                10,
                                        color: const Color(0xffdbdbdb),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.facebookSquare,
                                      color: Color(0xff385185),
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Log in with Facebook',
                                      style: TextStyle(
                                        color: Color(0xff385185),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                TextButton(
                                  child: const Text(
                                    'Forgotten your password?',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    primary: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                              padding: const EdgeInsets.all(10),
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
                                      "Don't have an account?",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/signup');
                                    },
                                    child: Container(
                                      child: const Text(
                                        " Sign up.",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0095f7),
                                          fontSize: 12,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(height: 10,),
                          Container(alignment: Alignment.center,child: Text('Get the app.', style: TextStyle(color: kMobileBackgroundColor),)),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.network('https://www.instagram.com/static/images/appstore-install-badges/badge_ios_english-en.png/180ae7a0bcf7.png', height: 40,),
                              Image.network('https://www.instagram.com/static/images/appstore-install-badges/badge_android_english-en.png/e9cd846dc748.png', height: 40,),
                            ],
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
