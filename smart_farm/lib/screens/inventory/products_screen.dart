import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> categories = [];
  List<dynamic> products = [];

  String productName = '';
  double productPrice = 0.0;
  int quantity = 0;
  String? selectedCategoryId;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      final data = await ApiService.get('/api/inventory/categories');
      setState(() {
        categories = data;
        if (categories.isNotEmpty) {
          selectedCategoryId = categories[0]['_id'];
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load categories';
      });
    }
  }

  Future<void> fetchProducts() async {
    try {
      final data = await ApiService.get('/api/inventory/products');
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load products';
        isLoading = false;
      });
    }
  }

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      await ApiService.post('/api/inventory/products', {
        'productName': productName,
        'productPrice': productPrice,
        'quantity': quantity,
        'productCategory': selectedCategoryId,
      });
      _formKey.currentState!.reset();
      fetchProducts();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to add product';
      });
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final url = '/api/inventory/products/$id';
      final response = await ApiService.delete(url);
      fetchProducts();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to delete product';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
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
                        Text('Add New Product',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Name'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter product name'
                              : null,
                          onSaved: (value) => productName = value ?? '',
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Price'),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (value) =>
                              value == null || double.tryParse(value) == null
                                  ? 'Please enter valid price'
                                  : null,
                          onSaved: (value) =>
                              productPrice = double.parse(value!),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value == null || int.tryParse(value) == null
                                  ? 'Please enter valid quantity'
                                  : null,
                          onSaved: (value) => quantity = int.parse(value!),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: 'Category'),
                          value: selectedCategoryId,
                          items:
                              categories.map<DropdownMenuItem<String>>((cat) {
                            return DropdownMenuItem<String>(
                              value: cat['_id'],
                              child: Text(cat['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategoryId = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select a category' : null,
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: addProduct,
                          child: Text('Add Product'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Product List',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: errorMessage != null
                        ? Center(child: Text(errorMessage!))
                        : ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final prod = products[index];
                              return ListTile(
                                title: Text(prod['productName']),
                                subtitle: Text(
                                    'Price: ₹${prod['productPrice'].toStringAsFixed(2)} | Quantity: ${prod['quantity']} | Category: ${prod['productCategory']?['name'] ?? ''}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteProduct(prod['_id']),
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
