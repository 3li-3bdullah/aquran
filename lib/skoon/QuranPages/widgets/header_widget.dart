import 'package:aquran/skoon/core/components/helper/constants.dart';
import 'package:aquran/skoon/core/components/helper/hive_helper.dart';
import 'package:aquran/skoon/core/quran_helper.dart';
import 'package:flutter/material.dart';

import 'package:quran/quran.dart';

class HeaderWidget extends StatelessWidget {
  var e;
  var jsonData;
  var indexOfTheme;

  HeaderWidget(
      {super.key, required this.e, required this.jsonData, this.indexOfTheme});

  @override
  Widget build(BuildContext context) {
 
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/images/888-02.png",
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: indexOfTheme != null
                  ? indexOfTheme != 1 &&indexOfTheme != 2 &&
                          indexOfTheme != 0 &&
                          indexOfTheme != 6 &&
                          indexOfTheme != 13 &&
                          indexOfTheme != 15
                      ? secondaryColors[indexOfTheme]
                      : null
                  : LocalDB.getValue("quranPageolorsIndex") != 1 &&LocalDB.getValue("quranPageolorsIndex") != 2 &&
                          LocalDB.getValue("quranPageolorsIndex") != 0&&
                          LocalDB.getValue("quranPageolorsIndex") != 6 &&
                          LocalDB.getValue("quranPageolorsIndex") != 13 &&
                          LocalDB.getValue("quranPageolorsIndex") != 15
                      ? secondaryColors[LocalDB.getValue("quranPageolorsIndex")]
                      : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 19.7, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "اياتها\n${getVerseCount(e["surah"])}",
                  style: TextStyle(
                      // color: accentColor,
                      color: indexOfTheme == null
                          ? primaryColors[LocalDB.getValue("quranPageolorsIndex")]
                              .withOpacity(.9)
                          : primaryColors[indexOfTheme].withOpacity(.92),
                      fontSize: 5,
                      fontFamily: "UthmanicHafs13"),
                ),
                Center(
                    child: RichText(
                      text: TextSpan(
text:    "${e["surah"]}",
                  style: TextStyle(
                    fontFamily: "arsura",
                    fontSize: 25,
                    color: indexOfTheme == null
                        ? primaryColors[LocalDB.getValue("quranPageolorsIndex")]
                            .withOpacity(.9)
                        : primaryColors[indexOfTheme].withOpacity(.9),
                  ),

                      ),
                  textAlign: TextAlign.center,
               
                )),
                Text(
                  "ترتيبها\n${e["surah"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      //color: accentColor,//
                      color: indexOfTheme == null
                          ? primaryColors[LocalDB.getValue("quranPageolorsIndex")]
                              .withOpacity(.9)
                          : primaryColors[indexOfTheme].withOpacity(.9),
                      fontSize: 5,
                      fontFamily: "UthmanicHafs13"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
