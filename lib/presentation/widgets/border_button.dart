import 'package:attendance/presentation/utils/utility.dart';
import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({
    Key key,
    this.text,
    this.ontap,
  }) : super(key: key);
  final String text;
  final Function ontap;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.white.withOpacity(0.4),
      minWidth: double.infinity,
      padding: kPadding10.copyWith(left: 20),
      onPressed: ontap,
      splashColor: secondaryColor,
      highlightColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white.withOpacity(0.7), width: 2),
        borderRadius: kBorderR10,
      ),
      child: Row(
        children: [
          Text(
            text,
            style: text30,
          ),
        ],
      ),
    );
  }
}
