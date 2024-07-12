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

  // repose form 
  // {
  //  "-O1adTZPP-Nog8vZzxXi":{"category":"Dairy","name":"Test 1","quantity":5},
  //  "-O1aifXjQcuGaycID560":{"category":"Fruit","name":"banana","quantity":2}
  // Ce qui donne
  //  (<String>) key : Map<String, dynamic> value , 
  // }

  void _loadItems() async{

    final url = Uri.https(
      'shopping-list-course-82756-default-rtdb.firebaseio.com',
      'shopping-list.json'
    );
    final response = await http.get(url);
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

    setState(() {
      _groceryItems = loadedItems;
    });
    
  }

  void _addItem () async {
     await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx){
        return const NewItem();
      })
    );

    _loadItems();
  }

  void _removeItem(GroceryItem item){
    setState (() {
      _groceryItems.remove(item);
    });
  }

  @override
  void initState() {
    _loadItems();
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

      body: _groceryItems.isEmpty ?
        Center(
          child: const Text("No item added yet."),
        )
      : 
        ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, index){
            return Dismissible(
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (direction) {
                _removeItem(_groceryItems[index]);
              },
              child: ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryItems[index].category.color,
                ),
                title: Text(_groceryItems[index].name),
                trailing: Text(_groceryItems[index].quantity.toString()),
              ),
            );
          },
        ),
    );
  }
}