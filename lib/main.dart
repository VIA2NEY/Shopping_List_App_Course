import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 42, 51, 59)
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60)
      ),
      home: const GroceryList(),
    );
  }
}

class HomeChallenge extends StatelessWidget {
  const HomeChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 42, 51, 59),
      appBar: AppBar(
        title: Text("Your Grocerries"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index){
                  return items(data[index]);
                },
              ),
          )
        ],
      ),
    );
  }
}

Widget items (Item item){
  return ListTile(
    leading: Icon(Icons.square, color: item.couleur,),
    title: Text(item.titre,/**  style: TextStyle(color: Colors.white),*/),
    trailing: Text(item.nbre.toString()),
  );
}

class Item {
  final Color couleur;
  final String titre;
  final int nbre;

  Item({
    required this.couleur,
    required this.titre,
    required this.nbre
  });


}

List data = [
  Item(couleur: Colors.blue, titre: 'Milk', nbre: 1),
  Item(couleur: Colors.greenAccent, titre: "Banana", nbre: 5),
  Item(couleur: Colors.red, titre: 'beef Steak', nbre: 1),
];