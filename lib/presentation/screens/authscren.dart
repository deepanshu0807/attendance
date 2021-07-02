import 'package:attendance/presentation/screens/login.dart';
import 'package:attendance/presentation/screens/register.dart';
import 'package:attendance/presentation/utils/constants.dart';
import 'package:attendance/presentation/utils/space.dart';
import 'package:attendance/presentation/utils/textstyles.dart';
import 'package:attendance/presentation/widgets/border_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: kPadding20.copyWith(left: 40, right: 40),
        height: screenHeight(context),
        width: screenWidth(context),
        decoration: BoxDecoration(
          gradient: gradientDecoration,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello !",
              style: text60,
            ),
            verticalSpaceMassive,
            verticalSpaceMassive,
            Text(
              "Don't have an account ?",
              style: text20.copyWith(color: Colors.grey[800]),
            ),
            verticalSpaceMedium15,
            BorderButton(
              text: "Register",
              ontap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Register()));
              },
            ),
            verticalSpaceLarge,
            Text(
              "Already have an account ?",
              style: text20.copyWith(color: Colors.grey[800]),
            ),
            verticalSpaceMedium15,
            BorderButton(
              text: "Login",
              ontap: () {
                Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
