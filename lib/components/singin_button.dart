import 'package:flutter/material.dart';

class SingInButton extends StatelessWidget {
  final String labelText;
  final Function() press;
  final AssetImage img;
  const SingInButton({
    Key? key,
    required this.labelText,
    required this.press,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: img,
              height: 35.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                labelText,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
