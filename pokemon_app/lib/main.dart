import 'package:flutter/material.dart';
import 'package:pokemon_app/poke_list_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode mode = ThemeMode.system;

    return MaterialApp(
        title: 'PokeApp',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: mode,
        home: const TopPage());
  }
}

class TopPage extends StatelessWidget {
  const TopPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) => PokeListItem(index: index),
        ),
      ),
      bottomNavigationBar:
          BottomNavigationBar(onTap: (index) => {}, items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'settings',
        )
      ]),
    );
  }
}
