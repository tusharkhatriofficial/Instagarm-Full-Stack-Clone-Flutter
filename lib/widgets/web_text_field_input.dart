import 'package:flutter/material.dart';

class WebTextFieldInput extends StatelessWidget {
  WebTextFieldInput({
    Key? key,
    required this.emailController,
    required this.hintText,
    required this.textInputType,
    required this.obscureText,
  }) : super(key: key);

  TextEditingController emailController;
  TextInputType textInputType;
  String hintText;
  bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        controller: emailController,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
          fillColor: const Color(0xfffafafa),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffdbdbdb),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffdbdbdb),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffdbdbdb),
            ),
          ),
          filled: true,
          contentPadding: const EdgeInsets.all(8.0),
        ),
        keyboardType: textInputType,
        obscureText: obscureText,
      ),
    );
  }
}
