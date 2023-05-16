import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  final int _initialIndex = 0;

  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: _initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Media"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _isGridView == true
                        ? _isGridView = false
                        : _isGridView = true;
                  });
                },
                icon: Icon(_isGridView
                    ? Icons.list_alt_outlined
                    : Icons.grid_view_outlined))
          ],
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.photo_outlined),
              text: "Photos",
            ),
            Tab(
              icon: Icon(Icons.video_library_outlined),
              text: "Video",
            ),
            Tab(
              icon: Icon(Icons.music_note_outlined),
              text: "Audio",
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            PhotosTab(
              gridView: _isGridView,
            ),
            const Icon(Icons.video_library_outlined),
            const Icon(Icons.music_note_outlined)
          ],
        ),
      ),
    );
  }
}

class PhotosTab extends StatefulWidget {
  PhotosTab({super.key, required this.gridView});
  final bool gridView;
  @override
  State<PhotosTab> createState() => _PhotosTabState();
}

class _PhotosTabState extends State<PhotosTab> {
  Directory? _currentDirectory;
  List<FileSystemEntity> _imageFiles = [];
  bool _isLoading = true;
  Future<void> getDirectory() async {
    Directory selectedDirectory = Directory('/storage/emulated/0');
    setState(() {
      _currentDirectory = selectedDirectory;
    });
  }

  bool _isImage(File file) {
    List<String> imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
    String extension = path.extension(file.path).toLowerCase();
    return imageExtensions.contains(extension);
  }

  void _refreshFiles() async {
    List<FileSystemEntity> images = [];
    await _scanDirectory(_currentDirectory!, images, "Android");
    setState(() {
      _imageFiles = images;
      _isLoading = false;
    });
  }

  Future<void> _scanDirectory(Directory dir, List<FileSystemEntity> images,
      String excludeFolder) async {
    List<FileSystemEntity> entities = dir.listSync(recursive: false);

    for (FileSystemEntity entity in entities) {
      if (entity is File && _isImage(entity)) {
        images.add(entity);
      } else if (entity is Directory) {
        String folderName = path.basename(entity.path);
        if (folderName != excludeFolder) {
          await _scanDirectory(entity, images, excludeFolder);
        }
      }
    }
  }

  Future<Uint8List> loadImage(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    return bytes;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        getDirectory();
        _refreshFiles();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _imageFiles.isNotEmpty
                ? widget.gridView
                    ? GridView.builder(
                        itemCount: _imageFiles.length,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: (1 / .2),
                                mainAxisSpacing: (1 / .2)),
                        itemBuilder: (context, index) {
                          final file = _imageFiles[index];
                          return InkWell(
                            onTap: () => OpenFile.open(file.path),
                            child: FutureBuilder<Uint8List>(
                              future: loadImage(file.path),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return AnimatedOpacity(
                                    opacity: 0.5,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    onEnd: () {
                                      setState(
                                          () {}); // Rebuild the widget tree to trigger another animation loop
                                    },
                                    child: const Icon(Icons.image_outlined),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Icon(
                                      Icons.broken_image_outlined);
                                } else if (!snapshot.hasData) {
                                  return const Icon(Icons.image_outlined);
                                } else {
                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.low,
                                  );
                                }
                              },
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: _imageFiles.length,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        itemBuilder: (context, index) {
                          final file = _imageFiles[index];
                          return ListTile(
                            onTap: () => OpenFile.open(file.path),
                            title: Text(file.path.split("/").last),
                            style: ListTileStyle.list,
                            leading: SizedBox(
                              width: 48,
                              height: 48,
                              child: Image(
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.low,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return const Icon(Icons.image_outlined);
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image_outlined),
                                image: FileImage(
                                  File(file.path),
                                  scale: 0.1,
                                ),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          );
                        },
                      )
                : const Center(
                    child: Text("Empty"),
                  ));
  }
}
