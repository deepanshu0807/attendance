import 'package:attendance/application/auth/signinform/signinform_bloc.dart';
import 'package:attendance/presentation/auth/auth_navigator.dart';
import 'package:attendance/presentation/utils/space.dart';
import 'package:attendance/presentation/utils/utility.dart';
import 'package:attendance/presentation/widgets/text_input_field.dart';
import 'package:attendance_shared/attendance_shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return AuthNavigator(
      child: BlocConsumer<SigninformBloc, SigninformState>(
        listener: (context, state) {
          state.authFailureOrSuccessOption.fold(
            () {},
            (either) {
              either.fold(
                (failure) {
                  setState(() {
                    _btnController.error();
                    _btnController.reset();
                  });
                  DisplayMessage.showErrorMessage(
                    context,
                    failure.map(
                      canceledByUser: (_) => DisplayMessage.canceledByUser,
                      serverError: (_) => DisplayMessage.serverError,
                      notAllowed: (_) => DisplayMessage.notAllowed,
                      invalidEmailPasswordCombination: (_) =>
                          DisplayMessage.invalidEmailPasswordCombination,
                      userNotFound: (_) => DisplayMessage.userNotFound,
                      invalidEmail: (_) => DisplayMessage.invalidEmail,
                      invalidEmailOrPasswordValue: (_) =>
                          DisplayMessage.invalidEmailOrPasswordValue,
                      invalidCredential: (_) =>
                          DisplayMessage.invalidCredential,
                      accountExistWithDifferentCredential: (_) =>
                          DisplayMessage.invalidCredential,
                      emailAlreadyExist: (_) =>
                          DisplayMessage.accountAlreadyExist,
                    ),
                  );
                },
                (_) {
                  debugPrint("Need to navigate to Home page");
                  // context
                  //     .read<AuthBloc>()
                  //     .add(const AuthEvent.authCheckRequested());
                  setState(() {
                    _btnController.success();
                  });
                  // Future.delayed(
                  //   const Duration(milliseconds: 2000),
                  //   () {
                  //     Navigator.pushReplacement(context,
                  //         CupertinoPageRoute(builder: (context) => Homepage()));
                  //   },
                  // );
                },
              );
            },
          );
        },
        builder: (context, state) {
          return Scaffold(
            body: Form(
              autovalidate: state.showErrorMessages,
              child: Container(
                padding: kPadding20.copyWith(left: 40, right: 40),
                height: screenHeight(context),
                width: screenWidth(context),
                decoration: BoxDecoration(
                  gradient: gradientDecoration,
                ),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            "images/back.png",
                            width: 50.w,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceMedium20,
                    Text(
                      "Login",
                      style: text50,
                    ),
                    verticalSpaceMassive,
                    verticalSpaceMassive,
                    Text(
                      " Email address",
                      style: text22,
                    ),
                    verticalSpaceMedium15,
                    TextInputCustomField(
                      label: 'abc@example.com',
                      iconData: Icons.mail,
                      controller: emailC,
                      textInputType: TextInputType.emailAddress,
                      onChanged: (val) {
                        context
                            .read<SigninformBloc>()
                            .add(SigninformEvent.emailChanged(val));
                      },
                      validator: (_) => context
                          .read<SigninformBloc>()
                          .state
                          .emailAddress
                          .value
                          .fold(
                            (f) => f.maybeMap(
                                invalidEmailAdress: (_) =>
                                    "Enter a valid email address",
                                orElse: () => null),
                            (_) => null,
                          ),
                    ),
                    verticalSpaceMedium25,
                    Text(
                      " Password",
                      style: text22,
                    ),
                    verticalSpaceMedium15,
                    TextInputCustomField(
                      textInputType: TextInputType.visiblePassword,
                      label: '******',
                      iconData: Icons.lock,
                      controller: passwordC,
                      onChanged: (val) {
                        context
                            .read<SigninformBloc>()
                            .add(SigninformEvent.passwordChanged(val));
                      },
                      validator: (_) => context
                          .read<SigninformBloc>()
                          .state
                          .password
                          .value
                          .fold(
                            (f) => f.maybeMap(
                              shortPassword: (_) => "Password is too short",
                              orElse: () => null,
                            ),
                            (_) => null,
                          ),
                    ),
                    verticalSpaceMedium30,
                    Center(
                      child: InkWell(
                        onTap: () {
                          context
                              .read<SigninformBloc>()
                              .add(SigninformEvent.forgetPasswordPressed());
                          if (emailC.text.isNotEmpty || emailC.text != "") {
                            DisplayMessage.showSuccessMessage(context,
                                'Check your email for resetting password');
                          }
                        },
                        child: Text(
                          "Forgot password ?",
                          style: text18.copyWith(color: Colors.grey[800]),
                        ),
                      ),
                    ),
                    verticalSpaceMedium25,
                    RoundedLoadingButton(
                      //borderRadius: 15,
                      color: Colors.black,
                      controller: _btnController,
                      onPressed: state.isLoging
                          ? null
                          : () {
                              context
                                  .read<SigninformBloc>()
                                  .add(SigninformEvent.loginPressed());
                            },
                      child: Text(
                        "Login",
                        style: text22.copyWith(
                          fontSize: 25.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
