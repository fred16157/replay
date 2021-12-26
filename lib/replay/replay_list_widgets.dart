import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:replay/replay/replay_list_item.dart';
import 'package:path/path.dart';

class ReplayList extends StatefulWidget {
  @override
  ReplayListState createState() => ReplayListState();
}

class ReplayListState extends State<ReplayList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReplayListItem>>(
      future: loadList(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              child: Text('EMPTY_REPLAYS'.tr()),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              File? file = snapshot.data?[index].file;
              return ListTile(
                leading: const Icon(Icons.play_arrow),
                title: Text(basename(file!.path)),
                subtitle: Text(file.statSync().modified.toString()),
              );
            },
          );
        }
        return Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('LOADING_REPLAYS'.tr()),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: LinearProgressIndicator(),
              )
            ],
          ),
        );
      },
    );
  }

  Future<List<ReplayListItem>> loadList() async {
    Directory dir = Directory(join((await getApplicationDocumentsDirectory()).path, './replays'));
    if(!dir.existsSync()) dir.createSync(recursive: true);
    List<ReplayListItem> replays = <ReplayListItem>[];
    for (FileSystemEntity file in dir.listSync(followLinks: true)) {
      if (file.path.endsWith('mp3')) {
        replays.add(ReplayListItem(file: File.fromUri(file.uri)));
      }
    }
    return replays;
  }
}
