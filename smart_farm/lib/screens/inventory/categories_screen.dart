import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> categories = [];

  String categoryName = '';

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final data = await ApiService.get('/api/inventory/categories');
      setState(() {
        categories = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load categories';
        isLoading = false;
      });
    }
  }

  Future<void> addCategory() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      await ApiService.post('/api/inventory/categories', {
        'name': categoryName,
      });
      _formKey.currentState!.reset();
      fetchCategories();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to add category';
      });
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await ApiService.delete('/api/inventory/categories/$id');
      fetchCategories();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to delete category';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Categories'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text('Add New Category',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Name'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter category name'
                              : null,
                          onSaved: (value) => categoryName = value ?? '',
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: addCategory,
                          child: Text('Add Category'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Category List',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: errorMessage != null
                        ? Center(child: Text(errorMessage!))
                        : ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              return ListTile(
                                title: Text(cat['name']),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteCategory(cat['_id']),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
