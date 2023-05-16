import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FileFolderInfo extends StatelessWidget {
  const FileFolderInfo({super.key, required this.pathDetails});
  final FileSystemEntity pathDetails;

  String _fileSizeFormatting(val) {
    const suffix = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(val) / log(1024)).floor();
    return '${(val / pow(1024, i)).toStringAsFixed(2)} ${suffix[i]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text("Properties"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    title: Text(pathDetails.path.split("/").last),
                    leading: const Icon(Icons.folder_outlined),
                  ),
                  ListTile(
                    title: Text(
                        'Modified ${DateFormat.yMMMMd('en_US').add_jm().format(pathDetails.statSync().modified)}'),
                    leading: const Icon(Icons.history_outlined),
                  ),
                  ListTile(
                    title: Text(pathDetails.statSync().type is File
                        ? "File"
                        : "Directory"),
                    leading: const Icon(Icons.file_present_outlined),
                  ),
                  ListTile(
                    title:
                        Text(_fileSizeFormatting(pathDetails.statSync().size)),
                    leading: const Icon(Icons.insert_drive_file_outlined),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
