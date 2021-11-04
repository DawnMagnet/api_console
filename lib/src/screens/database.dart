// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';

import '../routing.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({
    Key? key,
  }) : super(key: key);

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, String> postinfo;
  late Map<String, TextEditingController> controllers;
  List<List<Object>> tableElements = [
    ["1", "2", "3"],
    ["4", "5", "6"],
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_handleTabIndexChanged);
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newPath = _routeState.route.pathTemplate;
    if (newPath.startsWith('/database/add')) {
      _tabController.index = 0;
    } else if (newPath.startsWith('/database/sth')) {
      _tabController.index = 1;
    } else if (newPath == '/database/query') {
      _tabController.index = 2;
    }
    // _tabController.index = 0;
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    super.dispose();
  }

  List<TableRow> getTableContents() {
    return tableElements.map((element) {
      List<Widget> first = element
          .map((e) => Text(
                e.toString(),
                textAlign: TextAlign.center,
              ))
          .toList();
      List<Widget> second = [
        TextButton.icon(
          label: const Text('Delete'),
          icon: const Icon(Icons.delete),
          onPressed: () {},
        ),
        TextButton.icon(
          label: const Text('Edit'),
          icon: const Icon(Icons.edit),
          onPressed: () {},
        )
      ];
      List<Widget> line = [];
      line += first;
      line += second;
      return TableRow(children: line);
    }).toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('API Developer Tools'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Add',
              icon: Icon(Icons.add),
            ),
            Tab(
              text: '...',
              icon: Icon(Icons.star),
            ),
            Tab(
              text: 'Query',
              icon: Icon(Icons.query_stats_rounded),
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        // Add Page
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              textFieldsColumn(0.2),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(''),
              ),
              ElevatedButton.icon(
                label: const Text(
                  'Add Rules',
                  textScaleFactor: 1.3,
                ),
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ],
          ),
        ),
        // ... Page
        const Placeholder(),
        // Query Page
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                  verticalDirection: VerticalDirection.up,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    textFieldsColumn(0.1),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(''),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.search),
                      label: const Text(
                        'Search',
                        textScaleFactor: 1.3,
                      ),
                      onPressed: () {},
                    ),
                  ]),
              // const SizedBox.expand(child: Text("fds")),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                textDirection: TextDirection.ltr,
                textBaseline: TextBaseline.alphabetic,
                border: TableBorder.all(color: Colors.black),
                children: getTableContents(),
              ),
            ],
          ),
        )
      ]));

  RouteState get _routeState => RouteStateScope.of(context);

  void _handleTabIndexChanged() {
    switch (_tabController.index) {
      case 1:
        _routeState.go('/database/sth');
        break;
      case 2:
        _routeState.go('/database/query');
        break;
      case 0:
      default:
        _routeState.go('/database/add');
        break;
    }
  }
}
