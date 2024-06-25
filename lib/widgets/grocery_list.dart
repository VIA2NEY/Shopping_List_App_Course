import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {

  final List<GroceryItem> _groceryItems = [];

  void _addItem () async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx){
        return const NewItem();
      })
    );

    if (newItem == null) {
      return;
    }
    
    setState (() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item){
    setState (() {
      _groceryItems.remove(item);
    });
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