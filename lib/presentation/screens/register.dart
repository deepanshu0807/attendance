import 'package:attendance/application/auth/sign_up_form_bloc/signup_form_bloc.dart';
import 'package:attendance/presentation/auth/auth_navigator.dart';
import 'package:attendance/presentation/utils/space.dart';
import 'package:attendance/presentation/utils/utility.dart';
import 'package:attendance/presentation/widgets/text_input_field.dart';
import 'package:attendance_shared/attendance_shared.dart';
import 'package:attendance_shared/presentation/error_display_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Text & button controllers
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  UserRole role;

  @override
  Widget build(BuildContext context) {
    return AuthNavigator(
      child: BlocConsumer<SignupFormBloc, SignupFormState>(
        listener: (context, state) {
          state.signUpSuccessOrFailure.fold(
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
                  setState(() {
                    _btnController.success();
                  });
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
                padding: kPadding10.copyWith(left: 40, right: 40, top: 25),
                height: screenHeight(context),
                width: screenWidth(context),
                decoration: BoxDecoration(
                  gradient: gradientDecoration,
                ),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            "images/back.png",
                            width: 40.w,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceMedium20,
                    Text(
                      "Register",
                      style: text50,
                    ),
                    verticalSpaceLarge,
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey[100],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<UserRole>(
                          hint: Text(
                            role?.toValueString() ?? "Who are you ?",
                            style: text20.copyWith(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 35,
                            color: primaryColor,
                          ),
                          style: text20.copyWith(fontSize: 20),
                          items: [
                            UserRole.employee(),
                            UserRole.student(),
                          ].map(
                            (val) {
                              return DropdownMenuItem<UserRole>(
                                value: val,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: primaryColor,
                                    ),
                                    horizontalSpaceMedium20,
                                    Text(
                                      val.toValueString(),
                                      style: text20.copyWith(fontSize: 20),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (UserRole value) {
                            setState(() {
                              role = value;
                            });
                          },
                        ),
                      ),
                    ),
                    verticalSpaceMedium25,
                    Text(
                      " Name",
                      style: text22,
                    ),
                    verticalSpaceMedium15,
                    TextInputCustomField(
                      label: 'Full name',
                      iconData: Icons.account_box_rounded,
                      controller: nameC,
                      textInputType: TextInputType.name,
                      onChanged: (val) {
                        context
                            .read<SignupFormBloc>()
                            .add(SignupFormEvent.nameChanged(val));
                      },
                      validator: (_) =>
                          context.read<SignupFormBloc>().state.name.value.fold(
                                (f) => f.maybeMap(
                                    invalidName: (_) => "Name is too short",
                                    orElse: () => null),
                                (_) => null,
                              ),
                    ),
                    verticalSpaceMedium25,
                    Text(
                      " Phone number",
                      style: text22,
                    ),
                    verticalSpaceMedium15,
                    TextInputCustomField(
                      label: 'Your contact number',
                      iconData: Icons.contact_phone,
                      controller: phoneC,
                      textInputType: TextInputType.phone,
                      onChanged: (val) {
                        context
                            .read<SignupFormBloc>()
                            .add(SignupFormEvent.phoneChanged("+91$val"));
                      },
                      validator: (_) => context
                          .read<SignupFormBloc>()
                          .state
                          .phoneNumber
                          .value
                          .fold(
                            (f) => f.maybeMap(
                                invalidPhone: (_) =>
                                    "Enter a valid phone number",
                                orElse: () => null),
                            (_) => null,
                          ),
                    ),
                    verticalSpaceMedium25,
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
                            .read<SignupFormBloc>()
                            .add(SignupFormEvent.emailChanged(val));
                      },
                      validator: (_) => context
                          .read<SignupFormBloc>()
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
                            .read<SignupFormBloc>()
                            .add(SignupFormEvent.passwordChanged(val));
                      },
                      validator: (_) => context
                          .read<SignupFormBloc>()
                          .state
                          .password
                          .value
                          .fold(
                            (f) => f.maybeMap(
                                shortPassword: (_) => "Password is too short",
                                orElse: () => null),
                            (_) => null,
                          ),
                    ),
                    verticalSpaceMedium30,
                    RoundedLoadingButton(
                      //borderRadius: 15,
                      color: Colors.black,
                      controller: _btnController,
                      onPressed: state.isRegistering
                          ? null
                          : () {
                              context
                                  .read<SignupFormBloc>()
                                  .add(SignupFormEvent.registerPressed(role));
                            },
                      child: Text(
                        "Register",
                        style: text22.copyWith(
                          fontSize: 25.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    verticalSpaceMedium25,
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
