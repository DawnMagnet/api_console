// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:ui';
import 'package:flutter/material.dart';

// import '../data/library.dart';
// import '../routing.dart';
// import '../widgets/author_list.dart';
import 'package:http/http.dart' as http;

String requestConf() {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Map<String, Object> data = {
    "version": "1.0",
    "device_platform": "IOS",
    "device_id": "00000000",
    "os_api": 11,
    "channel": "unknown",
    "version_code": "8.1.4",
    "update_version_code": "8.1.4.01",
    "aid": "0000000",
    "cpu_arch": "aarch64"
  };
  Uri uri = Uri.parse('http://127.0.0.1:8080/conf');
  http.post(uri, headers: headers, body: data).then((res) {
    if (res.statusCode != 200) {
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    }
    return res.body;
  });
  return "";
}

class RequestsView extends StatefulWidget {
  const RequestsView({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<RequestsView> createState() => _RequestsView();
}

class _RequestsView extends State<RequestsView> {
  Widget textFieldWithLabel(
      String labelText, TextEditingController controller) {
    return SizedBox(
        width: 500,
        child: TextField(
          decoration: InputDecoration(labelText: labelText),
          controller: controller,
        ));
  }

  var addressController = TextEditingController(text: "127.0.0.1/8080");
  var platformController = TextEditingController(text: "Android");
  var deviceIDController = TextEditingController(text: "98Z8A3K72F90J376");
  var currentVersionController = TextEditingController();
  var nxtController = TextEditingController();
  late Map<String, String> postinfo;
  late Map<String, TextEditingController> controllers;
  Widget textFieldsColumn(double heightFactor) {
    List<Widget> textfields = [];

    controllers.forEach((key, value) {
      textfields.add(TextField(
        decoration: InputDecoration(labelText: key),
        controller: value,
      ));
    });
    final width = window.physicalSize.width;
    final height = window.physicalSize.height;
    return SizedBox(
        width: 500,
        height: height * heightFactor,
        child: ListView(
          children: textfields,
        ));
  }

  @override
  void initState() {
    super.initState();
    postinfo = {
      "version": "1.0",
      "device_platform": "IOS",
      "device_id": "00000000",
      "os_api": "11",
      "channel": "unknown",
      "version_code": "8.1.4",
      "update_version_code": "8.1.4.01",
      "aid": "0000000",
      "cpu_arch": "aarch64"
    };
    controllers = postinfo.map((key, value) {
      return MapEntry(key, TextEditingController(text: value));
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: textFieldsColumn(0.5),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var res = await showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Result'),
                content: const Text(
                    'The version needs to be updated.\nThe version is already up to date'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          tooltip: 'Send Request',
          child: const Icon(Icons
              .send_and_archive_rounded), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}

class AuthorsScreen extends StatelessWidget {
  final String title = 'Update APP Emulator';

  const AuthorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => RequestsView(title: title);
}
