import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'color_schemes.g.dart';

import 'page/home_page.dart';
import 'page/recent.dart';
import 'page/storage.dart';

import 'model/prov.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final settingsmodel = SettingsModel();
  settingsmodel.load();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AppPermissionState(),
      ),
      ChangeNotifierProvider.value(value: settingsmodel),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _defaultLightColorScheme = lightColorScheme;

  static const _defaultDarkColorScheme = darkColorScheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, child) => DynamicColorBuilder(
        builder: (dynamiclightColorScheme, dynamicdarkColorScheme) {
          return MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: "Manrope",
              colorScheme: dynamiclightColorScheme ?? _defaultLightColorScheme,
              iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              fontFamily: "Manrope",
              colorScheme: dynamicdarkColorScheme ?? _defaultDarkColorScheme,
              iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            themeMode: settings.themeMode,
            home: const Home(),
          );
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _pages = [const HomePage(), RecentPage(), StoragePage()];
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final _perm = Provider.of<AppPermissionState>(context);
    _perm.checkPermissionStatus();
    if (_perm.permissionStatus.isGranted) {
      return _buildHomePage();
    } else {
      return const RequestPermissionPage();
    }
  }

  Widget _buildHomePage() {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.folder_open), label: "Library"),
          NavigationDestination(
              icon: Icon(Icons.timelapse_rounded), label: "Recent"),
          NavigationDestination(
              icon: Icon(Icons.storage_outlined), label: "Storage"),
        ],
        selectedIndex: _selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}

class RequestPermissionPage extends StatelessWidget {
  const RequestPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionStateValue = Provider.of<AppPermissionState>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("This feature require storage permission"),
            ),
            FilledButton.tonal(
              style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(16.0),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  )),
              onPressed: () {
                permissionStateValue.requestPermission();
              },
              child: const Text("Request Permission"),
            )
          ],
        ),
      ),
    );
  }
}
