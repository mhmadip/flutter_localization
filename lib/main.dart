// This code is modified by Mohammad Salim to make it works in two ways instead
// of one way, to choose language automatically based on user device language or the user
// can click on a button to update the App UI.

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// A simple "rough and ready" example of localizing a Flutter app.
// Arabic and English (locale language codes 'en' and 'ar') are
// supported.

// The pubspec.yaml file must include flutter_localizations in its
// dependencies section. For example:
//
// dependencies:
//   flutter:
//     sdk: flutter
//   flutter_localizations:
//     sdk: flutter

// If you run this app with the device's locale set to anything but
// English or Arabic, the app's locale will be English. If you
// set the device's locale to Arabic, the app's locale will be
// Arabic.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter_localizations/flutter_localizations.dart';

// #docregion Demo
class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'title': 'Hello World',
      'name': 'Mohammad Salim',
    },
    'ar': {
      'title': 'اهلا بالعالم',
      'name': 'محمد سالم',
    },
  };

  static List<String> languages() => _localizedValues.keys.toList();

  String get title {
    return _localizedValues[locale.languageCode]!['title']!;
  }

  String get name {
    return _localizedValues[locale.languageCode]!['name']!;
  }
}
// #enddocregion Demo

// #docregion Delegate
class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      DemoLocalizations.languages().contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => true;
}
// #enddocregion Delegate

class DemoApp extends StatelessWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DemoLocalizations.of(context).title),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.language, color: Colors.white),
              label:
                  const Text('English', style: TextStyle(color: Colors.white)),
              onPressed: () => Demo.of(context)!
                  .setLocale(const Locale.fromSubtags(languageCode: 'en')),
            ),
            TextButton.icon(
              icon: const Icon(Icons.language, color: Colors.white),
              label: const Text('اللغة العربية',
                  style: TextStyle(color: Colors.white)),
              onPressed: () => Demo.of(context)!
                  .setLocale(const Locale.fromSubtags(languageCode: 'ar')),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(DemoLocalizations.of(context).title),
              Text(DemoLocalizations.of(context).name),
            ],
          ),
        ));
  }
}

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
  static _DemoState? of(BuildContext context) =>
      context.findAncestorStateOfType<_DemoState>();
}

class _DemoState extends State<Demo> {
  Locale? _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      onGenerateTitle: (BuildContext context) =>
          DemoLocalizations.of(context).title,
      localizationsDelegates: const [
        DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      // Watch out: MaterialApp creates a Localizations widget
      // with the specified delegates. DemoLocalizations.of()
      // will only find the app's Localizations widget if its
      // context is a child of the app.
      home: const DemoApp(),
    );
  }
}

void main() {
  runApp(const Demo());
}
