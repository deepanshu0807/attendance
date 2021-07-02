import 'package:attendance/presentation/auth/auth_navigator.dart';
import 'package:attendance/presentation/utils/utility.dart';
import 'package:attendance/presentation/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //startTimer();
    super.initState();
  }

  // startTimer() {
  //   Timer(Duration(seconds: 2), changeScreen);
  // }

  // changeScreen() async {
  //   await Navigator.pushReplacement(
  //       context, CupertinoPageRoute(builder: (context) => AppNavigator()));
  // }

  @override
  Widget build(BuildContext context) {
    return AuthNavigator(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          height: screenHeight(context),
          width: screenWidth(context),
          decoration: BoxDecoration(
            gradient: gradientDecoration,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Attendance",
                  style: text50.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              verticalSpaceMedium20,
              Loading(),
            ],
          ),
        ),
      ),
    );
  }
}
