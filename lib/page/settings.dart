import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/prov.dart';

import 'aboutpage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = Provider.of<SettingsModel>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text("Settings"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Appearance"),
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThemePage(),
                            )),
                        title: const Text("Theme"),
                        style: ListTileStyle.list,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      )
                    ],
                  ),
                  const Text("File management"),
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      SwitchListTile.adaptive(
                        value: settings.isHiddenFileShown,
                        onChanged: (value) {
                          settings.isHiddenFileShown = value;
                        },
                        title: const Text("Show hidden files"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      ListTile(
                        onTap: () {},
                        title: const Text("Index index"),
                        style: ListTileStyle.list,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ],
                  ),
                  const Text("About"),
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutPage(),
                            )),
                        title: const Text("About"),
                        style: ListTileStyle.list,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar.large(
          title: const Text("Appearance"),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Consumer<SettingsModel>(
                builder: (context, settings, child) => ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    RadioListTile(
                      value: ThemeMode.system,
                      groupValue: settings.themeMode,
                      onChanged: (value) {
                        settings.themeMode = value!;
                      },
                      title: const Text("System Default"),
                    ),
                    RadioListTile(
                      value: ThemeMode.light,
                      groupValue: settings.themeMode,
                      onChanged: (value) {
                        settings.themeMode = value!;
                      },
                      title: const Text("Light"),
                    ),
                    RadioListTile(
                      value: ThemeMode.dark,
                      groupValue: settings.themeMode,
                      onChanged: (value) {
                        settings.themeMode = value!;
                      },
                      title: const Text("Dark"),
                    ),
                  ],
                ),
              )
            ]),
          ),
        )
      ]),
    );
  }
}
