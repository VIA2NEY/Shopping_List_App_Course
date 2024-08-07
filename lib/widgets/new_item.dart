import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {

  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  void _saveItem() async{

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending= true;
      });

      final url = Uri.https(
        'shopping-list-course-82756-default-rtdb.firebaseio.com',
        'shopping-list.json'
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _enteredName, 
          'quantity': _enteredQuantity, 
          'category': _selectedCategory.name
        })
      );

      print('``````````the response.body is ${response.body}');
      // ``````````the response.body is {"name":"-O1bF9p3XSzmtLGhNPt6"}

      final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }
      
      Navigator.of(context).pop(
        GroceryItem(
          id: resData['name'], 
          name: _enteredName, 
          quantity: _enteredQuantity, 
          category: _selectedCategory
        )
      );
      // Navigator.of(context).pop(
      //   GroceryItem(
      //     id: DateTime.now().toString(), 
      //     name: _enteredName, 
      //     quantity: _enteredQuantity, 
      //     category: _selectedCategory
      //   )
      // );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name')
                ),
                validator: (value) {
                  if (value == null || 
                    value.isEmpty || 
                    value.trim().length <= 1 ){
                    return 'Doit contenir entre 1 et 50 caractere';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredName = newValue!;
                },
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity')
                      ),
                      initialValue: _enteredQuantity.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || 
                          value.isEmpty || 
                          int.tryParse(value) == null ||
                          int.tryParse(value)! < 0){
                          return 'Doit être un nombre valide positif';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredQuantity = int.parse(newValue!); // On conertir la valeur reçut en entier 
                      },
                      // Le widget TextFormField ne recoit que des valeur en string pour sa que on doit convertir en entier
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6,),
                                Text(category.value.name)
                              ],
                            )
                          )
                      ], 
                      onChanged: (value){
                        setState(() {
                           _selectedCategory = value!;
                        });
                       
                      }
                    ),
                  )
                ],
              ),

              SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSending ? null : (){
                      _formKey.currentState!.reset();
                    }, 
                    child: const Text('Annuler')
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem, // Ajouter pour que quand on envoie et que sa charge on ne puisse pas re-envoyer
                    child: _isSending ? 
                      const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(),) 
                    : const Text("Ajouter")
                  )
                ],
              )

            ],
          )
        ),
      ),
    );
  }
}