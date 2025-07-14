import 'package:aquran/skoon/core/components/helper/constants.dart';
import 'package:flutter/material.dart';

class Basmallah extends StatefulWidget {
  int index;
   Basmallah({super.key, required this.index });

  @override
  State<Basmallah> createState() => _BasmallahState();
}

class _BasmallahState extends State<Basmallah> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(width: screenSize.width,
      child: Padding(
        padding: EdgeInsets.only(
            left: (screenSize.width * .2),
            right: (screenSize.width * .2),
            top: 
            8,
            bottom: 2
            ),
        child:
    // Text("115",
    // textAlign: TextAlign.center,
    // style: TextStyle(
    //   color: primaryColors[widget.index],
    //   fontFamily: "arsura",fontSize: 40.sp
    // ),)     
      Image.asset(
          "assets/images/Basmala.png",
          color: primaryColors[widget.index].withOpacity(.9),
          width: MediaQuery.of(context).size.width*.4,
        ),
      ),
    );
  }
}
