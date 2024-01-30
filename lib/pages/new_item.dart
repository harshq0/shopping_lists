import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/grocery_items.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  var enterName = '';
  var _enterQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var isSending = false;

  void _saveItem() async {
    _formKey.currentState!.validate();
    _formKey.currentState!.save();
    setState(() {
      isSending = true;
    });
    final url = Uri.https(
        'grocerylists-5637b-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'name': enterName,
          'quantity': _enterQuantity,
          'category': _selectedCategory.title,
        },
      ),
    );

    print(response.body);
    print(response.statusCode);

    final Map<String, dynamic> resData = json.decode(response.body);
    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop(
      CategoryItem(
          id: resData['name'],
          name: enterName,
          quantity: _enterQuantity,
          category: _selectedCategory),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Add a new items',
          style: GoogleFonts.outfit(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Character must between 1 to 50.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  enterName = newValue!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        label: Text(
                          'Quantity',
                          style: GoogleFonts.outfit(),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enterQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, postivie number.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enterQuantity = int.parse(newValue!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      elevation: 3,
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
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 11,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: Text(
                      'Reset',
                      style: GoogleFonts.outfit(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isSending ? null : _saveItem,
                    child: isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            'Add Items',
                            style: GoogleFonts.outfit(),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
