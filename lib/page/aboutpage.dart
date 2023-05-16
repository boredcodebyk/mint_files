import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text("About"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Mint Files",
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                      ListTile(
                        title: const Text("Version"),
                        subtitle: const Text("0.0.1"),
                        style: ListTileStyle.list,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      ListTile(
                        title: const Text("License"),
                        onTap: () => showLicensePage(
                            context: context,
                            applicationName: "Mint Files",
                            applicationVersion: "0.0.1"),
                        style: ListTileStyle.list,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Developer",
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                      ListTile(
                        leading: SvgPicture.asset(
                          MediaQuery.of(context).platformBrightness ==
                                  Brightness.light
                              ? "assets/github-mark.svg"
                              : "assets/github-mark-white.svg",
                          semanticsLabel: 'Github',
                          height: 24,
                          width: 24,
                        ),
                        title: const Text("Github"),
                        onTap: () async {
                          const url = 'https://github.com/boredcodebyk';
                          if (!await launchUrl(Uri.parse(url))) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        style: ListTileStyle.list,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ],
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
