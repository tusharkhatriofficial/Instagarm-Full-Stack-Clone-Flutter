import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_ui_backend_clone/resources/auth_methods.dart';
import 'package:instagram_ui_backend_clone/utils/colors.dart';
import 'package:instagram_ui_backend_clone/utils/dimensions.dart';
import 'package:instagram_ui_backend_clone/utils/utils.dart';
import 'package:instagram_ui_backend_clone/widgets/text_field_input.dart';

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
      backgroundColor: MediaQuery.of(context).size.width < webScreenSize? kMobileBackgroundColor:
      Colors.black87,
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
              SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(top: 30, left: 50, right: 50, bottom: 50),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width/6,
                          ),
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height/1,
                          width: MediaQuery.of(context).size.width/3,
                          child: Image(
                            image: AssetImage('assets/images/loginimage1.png'),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.height/8,
                              top: MediaQuery.of(context).size.height/8,
                            ),
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height/1,
                            width: MediaQuery.of(context).size.width/3,
                            child: Column(
                              children: [
                                Material(
                                  elevation: 20,
                                  child: Container(
                                    color: kMobileBackgroundColor,
                                    //below column is of signin form
                                    child: Container(
                                      margin: EdgeInsets.all(50),
                                      child: Column(
                                        children: [
                                          //svg image
                                          SvgPicture.asset(
                                            'assets/images/ic_instagram.svg',
                                            color: kPrimaryColor,
                                            height: 54,
                                          ),
                                          const SizedBox(
                                            height: 54,
                                          ),
                                          //text field input for email
                                          TextFieldInput(
                                              textEditingController: _emailController,
                                              textInputType: TextInputType.emailAddress,
                                              hintText: "Enter your email"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // text field input for password
                                          TextFieldInput(
                                              textEditingController: _passwordController,
                                              textInputType: TextInputType.text,
                                              isPass: true,
                                              hintText: "Enter your password"),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          //login button
                                          InkWell(
                                            onTap: loginUser,
                                            child: Container(
                                              child: const Text("Log in"),
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                                            height: 40,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  height: 1,
                                                  width: MediaQuery.of(context).size.width/10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text('OR'),
                                              Flexible(
                                                child: Container(
                                                  height: 1,
                                                  width: MediaQuery.of(context).size.width/10,
                                                  color: Colors.white,
                                                ),
                                              ),

                                            ],
                                          ),
                                          const SizedBox(
                                            height: 40,
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
                                    ),
                                  ),
                                ),
                                Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              )),
    );
  }
}
