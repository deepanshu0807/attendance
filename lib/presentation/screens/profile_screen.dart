import 'package:attendance/presentation/utils/utility.dart';
import 'package:attendance/presentation/widgets/text_input_field.dart';
import 'package:attendance_shared/domain/auth/auth_domain.dart';
import 'package:attendance_shared/attendance_shared.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final AttendanceUser user;
  const ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: kPadding20.copyWith(left: 40),
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
              "Profile",
              style: text50,
            ),
            verticalSpaceMassive,
            Text(
              "Name",
              style: text18.copyWith(color: Colors.grey[600]),
            ),
            verticalSpaceSmall,
            Text(
              widget.user.name.getOrElse("NA"),
              style: text30,
              overflow: ell,
            ),
            verticalSpaceLarge,
            Text(
              "Email address",
              style: text18.copyWith(color: Colors.grey[600]),
            ),
            verticalSpaceSmall,
            Text(
              widget.user.emailAddress.getOrElse("NA"),
              style: text30,
              overflow: ell,
            ),
            verticalSpaceLarge,
            Text(
              "Password",
              style: text18.copyWith(color: Colors.grey[600]),
            ),
            verticalSpaceSmall,
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UpdatePassword();
                        });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: kBorderR20,
                    ),
                    side: BorderSide(color: Colors.grey[200]),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Colors.black,
                      ),
                      horizontalSpaceTiny,
                      Text(
                        "Update Password",
                        style: text16,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key key}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController currC = TextEditingController();
  TextEditingController newC = TextEditingController();

  void _changePassword(String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user.email, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        DisplayMessage.showSuccessMessage(context, "Updated successfully");
        Navigator.pop(context);
      }).catchError((error) {
        DisplayMessage.showErrorMessage(context, "Something went wrong");
      });
    }).catchError((err) {
      print(err.toString());
      DisplayMessage.showErrorMessage(
          context, "You entered incorrect password");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: kRoundedShape,
      child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: kBorderR20,
            color: Colors.white,
          ),
          padding: kPadding20,
          child: Column(
            mainAxisAlignment: mainSB,
            children: [
              Text(
                "Password",
                style: text30.copyWith(fontSize: 28.sp),
              ),
              Column(
                crossAxisAlignment: crossS,
                children: [
                  Text(
                    " Current password",
                    style: text16.copyWith(color: Colors.grey[700]),
                  ),
                  verticalSpaceTiny,
                  TextInputCustomField(
                    textInputType: TextInputType.visiblePassword,
                    label: 'Enter',
                    iconData: Icons.lock,
                    controller: currC,
                    onChanged: (val) {},
                  ),
                  verticalSpaceMedium15,
                  Text(
                    " New password",
                    style: text16.copyWith(color: Colors.grey[700]),
                  ),
                  verticalSpaceTiny,
                  TextInputCustomField(
                    textInputType: TextInputType.visiblePassword,
                    label: 'Enter',
                    iconData: Icons.lock,
                    controller: newC,
                    onChanged: (val) {},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: mainC,
                children: [
                  FlatButton(
                    onPressed: () {
                      if (currC.text.isNotEmpty && newC.text.isNotEmpty)
                        _changePassword(currC.text, newC.text);
                      else
                        DisplayMessage.showErrorMessage(
                            context, "Enter a password first");
                    },
                    shape: kRoundedShape,
                    color: secondaryColor,
                    child: Text(
                      "Save",
                      style: text20.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  horizontalSpaceMedium15,
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: kRoundedShape,
                    color: primaryColor,
                    child: Text(
                      "Cancel",
                      style: text20,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
