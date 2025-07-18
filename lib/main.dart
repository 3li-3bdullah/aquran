import 'dart:convert';
import 'dart:developer';

import 'package:aquran/skoon/QuranPages/views/quranDetailsPage.dart';
import 'package:aquran/skoon/QuranPages/views/quran_sura_list.dart';
import 'package:aquran/skoon/controllers/quran_page_player_bloc.dart';
import 'package:aquran/skoon/core/components/helper/hive_helper.dart';
import 'package:aquran/skoon/core/quran_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:quran/quran.dart' as quran;

String? jsonData;
String? quarterData;
String languageCode = 'ar';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await LocalDB.init();
  } catch (e) {
    print('Failed to initialize Hive: $e');
    // Handle error (e.g., show user message)
  }
  await loadData();
  runApp(const MyApp());
}

Future<void> loadData() async {
  jsonData = await rootBundle.loadString('assets/data/surahs.json');
  quarterData = await rootBundle.loadString('assets/data/quarters.json');
  // await LocalDB.init();
  LocalDB.updateValue('darkMode', true);
  // bool isDarkMode = LocalDB.getValue('darkMode');

  // SurahDB? surah = LocalDB.getSurah(1);
  // if (surah != null) {
  //   surah.isBookmarked = true;
  //   LocalDB.updateSurah(surah);
  // }

  // List<Verse> verses = LocalDB.getVerses(1);
  // verses[0].isMemorized = true;
  // LocalDB.updateVerse(verses[0]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    log(jsonData.toString());
    log(quarterData.toString());
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      locale: const Locale('ar'), // Arabic language code
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      home: BlocProvider(
        create: (context) => QuranPagePlayerBloc(),
        child: SurahListPage(
            jsonData: json.decode(jsonData ?? '{}'),
            quarterjsonData: json.decode(quarterData ?? '{}')),
        // QuranDetailsPage(
        //     shouldHighlightSura: false,
        //     shouldHighlightText: false,
        //     highlightVerse: "",
        //     jsonData: jsonDecode(jsonData as String) as List<dynamic>,
        //     quarterJsonData: jsonDecode(quarterData as String) as List<dynamic>,
        //     pageNumber: quran.getPageNumber(1, 1)),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
