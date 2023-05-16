import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';

import 'download_page.dart';
import 'files_list.dart';
import 'settings.dart';

import 'media.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _storagepath = [];

  Future<void> getPath() async {
    var paths = await ExternalPath.getExternalStorageDirectories();
    List<String> storagepath = [];
    for (var path in paths) {
      storagepath.add((path));
    } // [/storage/emulated/0, /storage/B3AE-4D28]
    setState(() {
      _storagepath = storagepath;
    });
    // please note: B3AE-4D28 is external storage (SD card) folder name it can be any.
  }

  @override
  void initState() {
    super.initState();
    getPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Library"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  )),
              icon: const Icon(Icons.settings_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Text(
                "Category",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (1 / .4),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8),
              children: [
                FilledButton.tonalIcon(
                    style: ButtonStyle(
                        alignment: Alignment.centerLeft,
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(24.0),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        )),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MediaPage(),
                          ));
                    },
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text("Media")),
                FilledButton.tonalIcon(
                    style: ButtonStyle(
                        alignment: Alignment.centerLeft,
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(24.0),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        )),
                    onPressed: () {},
                    icon: const Icon(Icons.note_outlined),
                    label: const Text("Document")),
                FilledButton.tonalIcon(
                    style: ButtonStyle(
                        alignment: Alignment.centerLeft,
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(24.0),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        )),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DownloadPage(
                              rootPath: "/storage/emulated/0/Download",
                            ),
                          ));
                    },
                    icon: const Icon(Icons.file_download_outlined),
                    label: const Text("Downloads")),
                FilledButton.tonalIcon(
                    style: ButtonStyle(
                        alignment: Alignment.centerLeft,
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(24.0),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        )),
                    onPressed: () {},
                    icon: const Icon(Icons.android_outlined),
                    label: const Text("Installation files")),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Text(
                "Storage",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            GridView.builder(
              itemCount: _storagepath.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: (1 / .2),
                  mainAxisSpacing: 8),
              itemBuilder: (context, index) {
                final eachStoragePath = _storagepath[index];
                return eachStoragePath == '/storage/emulated/0'
                    ? FilledButton.tonalIcon(
                        style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.all(24.0),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            )),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FileListPage(
                                  rootPath: eachStoragePath,
                                ),
                              ));
                        },
                        icon: const Icon(Icons.phone_android_outlined),
                        label: const Text("Internal Storage"))
                    : FilledButton.tonalIcon(
                        style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.all(24.0),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            )),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FileListPage(
                                  rootPath: eachStoragePath,
                                ),
                              ));
                        },
                        icon: const Icon(Icons.sd_card_outlined),
                        label: const Text("SD Card"));
              },
            )
          ],
        ),
      ),
    );
  }
}
