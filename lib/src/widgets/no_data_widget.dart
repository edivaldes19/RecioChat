import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:recio_chat/src/utils/my_colors.dart';

class NoDataWidget extends StatelessWidget {
  String text = '';
  NoDataWidget({Key? key, this.text = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Lottie.asset('assets/animations/no_data_found.json'),
      const SizedBox(height: 15),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: MyColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)))
    ]));
  }
}
