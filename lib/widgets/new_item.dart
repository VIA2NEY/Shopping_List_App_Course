import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {

  final _formKey = GlobalKey<FormState>();

  void _saveItem(){
    _formKey.currentState!.validate();
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
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity')
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || 
                          value.isEmpty || 
                          int.tryParse(value) == null ||
                          int.tryParse(value)! <= 1){
                          return 'Doit être un nombre valide positif';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: DropdownButtonFormField(
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
                    onPressed: (){
                      _formKey.currentState!.reset();
                    }, 
                    child: const Text('Annuler')
                  ),
                  ElevatedButton(
                    onPressed: _saveItem, 
                    child: const Text("Ajouter")
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