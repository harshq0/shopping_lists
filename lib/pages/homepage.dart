import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/grocery_items.dart';
import 'package:shopping_app/pages/new_item.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryItem> _groceryItem = [];
  var isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadItem();
  }

  void loadItem() async {
    final url = Uri.https(
        'grocerylists-5637b-default-rtdb.firebaseio.com', 'shopping-list.json');
    final resposne = await http.get(url);

    if (resposne.statusCode >= 400) {
      setState(() {
        error = 'Failed to fetch data. please try again later.';
      });
    }
    final Map<String, dynamic> listData = json.decode(resposne.body);
    final List<CategoryItem> loadedItems = [];
    for (final items in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == items.value['category'])
          .value;
      loadedItems.add(
        CategoryItem(
            id: items.key,
            name: items.value['name'],
            quantity: items.value['quantity'],
            category: category),
      );
    }
    setState(() {
      _groceryItem = loadedItems;
      isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<CategoryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItemScreen(),
      ),
    );

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItem.add(newItem);
    });
  }

  void removeItems(CategoryItem item) {
    setState(() {
      _groceryItem.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        'No item added yet.',
        style: GoogleFonts.outfit(),
      ),
    );

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItem.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItem.length,
        itemBuilder: (context, index) {
          return Dismissible(
            onDismissed: (direction) {
              removeItems(_groceryItem[index]);
            },
            key: ValueKey(_groceryItem[index].id),
            child: ListTile(
              title: Text(
                _groceryItem[index].name,
                style: GoogleFonts.outfit(),
              ),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItem[index].category.color,
              ),
              trailing: Text(
                _groceryItem[index].quantity.toString(),
                style: GoogleFonts.outfit(),
              ),
            ),
          );
        },
      );
    }

    if (error != null) {
      content = Center(
        child: Text(error!),
      );
    }
    return Scaffold(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          " Your's Grocery ",
          style: GoogleFonts.outfit(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
