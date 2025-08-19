import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> products = [];
  List<dynamic> customers = [];
  List<dynamic> sales = [];

  String? selectedProductId;
  int quantity = 1;
  String? selectedCustomerId;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCustomers();
    fetchSales();
  }

  Future<void> fetchProducts() async {
    try {
      final data = await ApiService.get('/api/inventory/products');
      setState(() {
        products = data;
        if (products.isNotEmpty) {
          selectedProductId = products[0]['_id'];
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load products';
      });
    }
  }

  Future<void> fetchCustomers() async {
    try {
      final data = await ApiService.get('/api/inventory/customers');
      setState(() {
        customers = data;
        if (customers.isNotEmpty) {
          selectedCustomerId = customers[0]['_id'];
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load customers';
      });
    }
  }

  Future<void> fetchSales() async {
    try {
      final data = await ApiService.get('/api/inventory/sales');
      setState(() {
        sales = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load sales';
        isLoading = false;
      });
    }
  }

  Future<void> addSale() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      await ApiService.post('/api/inventory/sales', {
        'prdID': selectedProductId,
        'quantity': quantity,
        'customer': selectedCustomerId,
      });
      _formKey.currentState!.reset();
      fetchSales();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to add sale';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sale'),
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
                        Text('Add Sale',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: 'Product'),
                          value: selectedProductId,
                          items: products.map<DropdownMenuItem<String>>((prod) {
                            return DropdownMenuItem<String>(
                              value: prod['_id'],
                              child: Text(prod['productName']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedProductId = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select a product' : null,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number,
                          initialValue: '1',
                          validator: (value) {
                            if (value == null || int.tryParse(value) == null) {
                              return 'Please enter valid quantity';
                            }
                            if (int.parse(value) <= 0) {
                              return 'Quantity must be greater than zero';
                            }
                            return null;
                          },
                          onSaved: (value) => quantity = int.parse(value!),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: 'Customer'),
                          value: selectedCustomerId,
                          items:
                              customers.map<DropdownMenuItem<String>>((cust) {
                            return DropdownMenuItem<String>(
                              value: cust['_id'],
                              child: Text(cust['fullName']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCustomerId = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select a customer' : null,
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: addSale,
                          child: Text('Add Sale'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Sales List',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: errorMessage != null
                        ? Center(child: Text(errorMessage!))
                        : ListView.builder(
                            itemCount: sales.length,
                            itemBuilder: (context, index) {
                              final sale = sales[index];
                              return ListTile(
                                title:
                                    Text(sale['prdID']?['productName'] ?? ''),
                                subtitle: Text(
                                    'Quantity: ${sale['quantity']} | Customer: ${sale['customer']?['fullName'] ?? ''} | Date: ${DateTime.parse(sale['date']).toLocal().toString().split(' ')[0]}'),
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
