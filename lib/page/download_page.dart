import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import '../model/prov.dart';

class DownloadPage extends StatefulWidget {
  final String rootPath;
  const DownloadPage({super.key, required this.rootPath});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  Directory? _currentDirectory;
  List<FileSystemEntity> _files = [];
  List<BreadCrumbItem> _breadcrumbs = [];

  Future<void> getDirectory() async {
    Directory selectedDirectory = Directory(widget.rootPath);
    setState(() {
      _currentDirectory = selectedDirectory;
    });
  }

  void _updateBreadcrumbs() {
    final breadcrumbs = <BreadCrumbItem>[];

    widget.rootPath == "/storage/emulated/0/Download"
        ? breadcrumbs.add(BreadCrumbItem(
            content: const Text('Download'),
            onTap: () {
              setState(() {
                Directory _directory = Directory(widget.rootPath);
                _onFolderTap(_directory);
              });
              _updateBreadcrumbs();
            },
            borderRadius: BorderRadius.circular(6),
            padding: const EdgeInsets.all(8.0),
          ))
        : breadcrumbs.add(BreadCrumbItem(
            content: const Text('SD Card'),
            onTap: () {
              setState(() {
                Directory _directory = _currentDirectory!.parent;
                _onFolderTap(_directory);
              });
              _updateBreadcrumbs();
            },
            borderRadius: BorderRadius.circular(6),
            padding: const EdgeInsets.all(8.0),
          ));
    String currentPath = '';
    List<String> subPaths = [];
    if (widget.rootPath == "/storage/emulated/0/Download") {
      subPaths = _currentDirectory!.path.split('/').sublist(5);
    } else {
      subPaths = _currentDirectory!.path.split('/').sublist(3);
    }
    for (var segment in subPaths) {
      currentPath += '/$segment';
      breadcrumbs.add(BreadCrumbItem(
        content: Text(segment),
        onTap: () {
          final directory =
              Directory(_currentDirectory!.parent.path + currentPath);
          _onFolderTap(directory);
          _updateBreadcrumbs();
        },
        borderRadius: BorderRadius.circular(6),
        padding: const EdgeInsets.all(8.0),
      ));
    }
    setState(() {
      _breadcrumbs = breadcrumbs;
    });
  }

  void _onFolderTap(Directory directory) {
    setState(() {
      _currentDirectory = directory;
      _refreshFiles();
      _updateBreadcrumbs();
    });
  }

  void _refreshFiles() {
    setState(() {
      _files = _currentDirectory!.listSync();
    });
  }

  Future<bool> _onBackButtonPressed() {
    if (_currentDirectory!.path == widget.rootPath) {
      Navigator.pop(context);
      return Future.value(true);
    } else {
      final parent = Directory(_currentDirectory!.parent.path);
      setState(() {
        _currentDirectory = parent;
      });
      _updateBreadcrumbs();
      _refreshFiles();
      return Future.value(false);
    }
  }

  static Map<String, IconData> fileIcons = {
    'audio/aac': Icons.music_note,
    'audio/aiff': Icons.music_note,
    'audio/amr': Icons.music_note,
    'audio/ape': Icons.music_note,
    'audio/au': Icons.music_note,
    'audio/flac': Icons.music_note,
    'audio/gsm': Icons.music_note,
    'audio/m4a': Icons.music_note,
    'audio/mid': Icons.music_note,
    'audio/mp2': Icons.music_note,
    'audio/mp3': Icons.music_note,
    'audio/ogg': Icons.music_note,
    'audio/wav': Icons.music_note,
    'audio/wma': Icons.music_note,
    'video/3gpp': Icons.videocam,
    'video/avi': Icons.videocam,
    'video/flv': Icons.videocam,
    'video/gif': Icons.image,
    'video/mpeg': Icons.videocam,
    'video/mp4': Icons.videocam,
    'video/quicktime': Icons.videocam,
    'video/rm': Icons.videocam,
    'video/swf': Icons.videocam,
    'video/vob': Icons.videocam,
    'video/webm': Icons.videocam,
    'image/bmp': Icons.image,
    'image/gif': Icons.image,
    'image/jpeg': Icons.image,
    'image/jpg': Icons.image,
    'image/png': Icons.image,
    'image/tiff': Icons.image,
    'application/pdf': Icons.picture_as_pdf,
    'application/msword': Icons.notes_outlined,
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        Icons.notes_outlined,
    'application/vnd.oasis.opendocument.text': Icons.notes_outlined,
    'application/rtf': Icons.notes_outlined,
    'text/plain': Icons.text_fields,
    'application/vnd.ms-excel': Icons.table_chart_outlined,
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        Icons.table_chart_outlined,
    'application/x-csrc': Icons.code,
    'text/x-c++src': Icons.code,
    'text/x-csharp': Icons.code,
    'text/x-chdr': Icons.code,
    'text/x-c++hdr': Icons.code,
    'text/x-java': Icons.code,
    'text/x-javascript': Icons.code,
    'text/x-php': Icons.code,
    'text/x-python': Icons.code,
    'text/x-ruby': Icons.code,
    'application/octet-stream': Icons.insert_drive_file,
    'text/csv': Icons.table_chart_outlined,
    'application/json': Icons.note_outlined,
    'audio/mpeg': Icons.music_note,
    'application/x-shockwave-flash': Icons.videocam,
  };

  IconData? getIcon(String contentType) {
    if (fileIcons.containsKey(lookupMimeType(contentType))) {
      return fileIcons[lookupMimeType(contentType)];
    } else {
      return Icons.insert_drive_file_outlined;
    }
  }

  bool _isHidden(FileSystemEntity entity) {
    String entityName = path.basename(entity.path);
    return entityName.startsWith('.');
  }

  @override
  void initState() {
    super.initState();
    getDirectory();
    _refreshFiles();
    _updateBreadcrumbs();
  }

  @override
  Widget build(BuildContext context) {
    _files.sort((a, b) => a.path.compareTo(b.path));
    _files.sort((a, b) {
      if (a is Directory && b is File) {
        return -1;
      } else if (a is File && b is Directory) {
        return 1;
      } else {
        return a.path.compareTo(b.path);
      }
    });
    List<FileSystemEntity> filesList = [];
    final settings = Provider.of<SettingsModel>(context);
    if (!settings.isHiddenFileShown) {
      setState(() {
        filesList = _files.where((file) => !_isHidden(file)).toList();
      });
    } else {
      setState(() {
        filesList = _files;
      });
    }
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Download"),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.search_outlined)),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert_outlined),
            ),
          ],
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                height: AppBar().preferredSize.height,
                alignment: Alignment.centerLeft,
                child: BreadCrumb(
                  items: _breadcrumbs,
                  divider: const Icon(Icons.chevron_right),
                  overflow: ScrollableOverflow(
                    keepLastDivider: false,
                    reverse: false,
                    direction: Axis.horizontal,
                  ),
                ),
              )),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _files.isNotEmpty
                    ? ListView.builder(
                        itemCount: filesList.length,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        itemBuilder: (context, index) {
                          final dir = filesList[index];
                          return ListTile(
                            onTap: () {
                              if (dir is Directory) {
                                _onFolderTap(dir);
                              } else if (dir is File) {
                                OpenFile.open(dir.path);
                              }
                            },
                            leading: SizedBox(
                              width: 48,
                              height: 48,
                              child: dir is Directory
                                  ? const Icon(Icons.folder_outlined)
                                  : Icon(getIcon(dir.path)),
                            ),
                            title: Text(
                              dir.path.split('/').last,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Text("mm"),
                            style: ListTileStyle.list,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          );
                        },
                      )
                    : const Center(
                        child: Text("The folder is empty"),
                      ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FilledButton.tonal(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Create"))
                    ],
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.create_new_folder_outlined),
        ),
      ),
    );
  }
}
