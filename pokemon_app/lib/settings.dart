import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

int modeToVal(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return 1;
    case ThemeMode.dark:
      return 2;
    case ThemeMode.light:
      return 3;
    default:
      return 0;
  }
}

ThemeMode valToMode(int val) {
  switch (val) {
    case 1:
      return ThemeMode.system;
    case 2:
      return ThemeMode.dark;
    case 3:
      return ThemeMode.light;
    default:
      return ThemeMode.system;
  }
}

Future<void> saveThemeMode(ThemeMode mode) async {
  final pref = await SharedPreferences.getInstance();
  pref.setInt('theme_mode', modeToVal(mode));
}

Future<ThemeMode> loadThemeMode() async {
  final pref = await SharedPreferences.getInstance();
  final ret = valToMode(pref.getInt('theme_mode') ?? 0);
  return ret;
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    loadThemeMode().then((val) => setState(() => _themeMode = val));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.lightbulb),
          title: const Text('Dark/Light Mode'),
          trailing: Text((_themeMode == ThemeMode.system)
              ? 'System'
              : (_themeMode == ThemeMode.dark ? 'Dark' : 'Light')),
          onTap: () async {
            var ret = await Navigator.of(context).push<ThemeMode>(
              MaterialPageRoute(
                builder: (context) => ThemeModeSelectionPage(mode: _themeMode),
              ),
            );
            setState(() => _themeMode = ret!);
            await saveThemeMode(_themeMode);
          },
        ),
        SwitchListTile(
          title: const Text('Switch'),
          value: true,
          onChanged: (yes) => {},
        ),
        CheckboxListTile(
          title: const Text('Checkbox'),
          value: true,
          onChanged: (yes) => {},
        ),
        RadioListTile(
          title: const Text('Radio'),
          value: true,
          groupValue: true,
          onChanged: (yes) => {},
        ),
      ],
    );
  }
}

class ThemeModeSelectionPage extends StatefulWidget {
  const ThemeModeSelectionPage({
    Key? key,
    required this.mode,
  }) : super(key: key);
  final ThemeMode mode;

  @override
  _ThemeModeSelectionPageState createState() => _ThemeModeSelectionPageState();
}

class _ThemeModeSelectionPageState extends State<ThemeModeSelectionPage> {
  late ThemeMode _current;
  @override
  void initState() {
    super.initState();
    _current = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop<ThemeMode>(context, _current),
              ),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: _current,
              title: const Text('System'),
              onChanged: (val) => {setState(() => _current = val!)},
            ),
            RadioListTile(
              value: ThemeMode.dark,
              groupValue: _current,
              title: const Text('Dark'),
              onChanged: (val) => {setState(() => _current = val!)},
            ),
            RadioListTile(
              value: ThemeMode.light,
              groupValue: _current,
              title: const Text('Light'),
              onChanged: (val) => {setState(() => _current = val!)},
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeModeNotifier extends ChangeNotifier {
  late ThemeMode _themeMode;
  themeModeNotifier() {
    _init();
  }

  ThemeMode get mode => _themeMode;

  void _init() async {
    _themeMode = await loadThemeMode();
    notifyListeners();
  }

  void update(ThemeMode nextMode) {
    _themeMode = nextMode;
    saveThemeMode(nextMode);
    notifyListeners();
  }
}
