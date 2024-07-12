import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {

  List<GroceryItem> _groceryItems = [];
  late Future <List<GroceryItem>> _loadedItems;
  String? _error;

  // repose form 
  // {
  //  "-O1adTZPP-Nog8vZzxXi":{"category":"Dairy","name":"Test 1","quantity":5},
  //  "-O1aifXjQcuGaycID560":{"category":"Fruit","name":"banana","quantity":2}
  // Ce qui donne
  //  (<String>) key : Map<String, dynamic> value , 
  // }

  Future <List<GroceryItem>> _loadItems() async{

    final url = Uri.https(
      'shopping-list-course-82756-default-rtdb.firebaseio.com',
      'shopping-list.json'
    );
    
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception('Impossible de recupére les articles du marché. Réessayé plus tard');
      
    }

    if (response.body == 'null') {
      return [];
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {

      // Vue que dans mon GroceryItem category est la class Category et que firebase ne me ramene que le titre 
      // donc avec le titre j'effectue une recherche qui match avec le titre pour retourner la valeur
      final categori = categories.entries.firstWhere(
        (catItem) => catItem.value.name == item.value['category']
      ).value;

      loadedItems.add(
        GroceryItem(
          id: item.key, 
          name: item.value['name'], 
          quantity: item.value['quantity'], 
          category: categori
        )
      );
    }
    
    return loadedItems;
    
  

  }

  void _addItem () async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx){
        return const NewItem();
      })
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async{
    final index = _groceryItems.indexOf(item);
    setState (() {
      _groceryItems.remove(item);
    });

    final url = Uri.https(
      'shopping-list-course-82756-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json'
    );
    final response = await http.delete(url);

    if (response.statusCode >= 400) {

      ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Une Erreur c'est produite lors de la supppresion."),
          duration: Duration(seconds: 3),
        )
      );

      setState(() {
        _groceryItems.insert(index, item);
      });
      
    }

  }

  @override
  void initState() {
    _loadedItems =_loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Grocerries'),
        actions: [
          IconButton(
            onPressed: _addItem, 
            icon: Icon(Icons.add)
          )
        ],
      ),

      body: FutureBuilder(
        future: _loadedItems, 
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
              )
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Aucun article ajouté"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index){
              return Dismissible(
                key: ValueKey(snapshot.data![index].id),
                onDismissed: (direction) {
                  _removeItem(snapshot.data![index]);
                },
                child: ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: snapshot.data![index].category.color,
                  ),
                  title: Text(snapshot.data![index].name),
                  trailing: Text(snapshot.data![index].quantity.toString()),
                ),
              );
            },
          );

        }
      ),
      
      
      /*content*/
        
    );
  }
}