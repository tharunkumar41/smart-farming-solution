import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> customers = [];

  String fullName = '';
  String phoneNo = '';
  String email = '';
  String address = '';

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      final data = await ApiService.get('/api/inventory/customers');
      setState(() {
        customers = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load customers';
        isLoading = false;
      });
    }
  }

  Future<void> addCustomer() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      await ApiService.post('/api/inventory/customers', {
        'fullName': fullName,
        'phoneNo': phoneNo,
        'email': email,
        'address': address,
      });
      _formKey.currentState!.reset();
      fetchCustomers();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to add customer';
      });
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await ApiService.delete('/api/inventory/customers/$id');
      fetchCustomers();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to delete customer';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Customers'),
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
                        Text('Add New Customer',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Full Name'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter full name'
                              : null,
                          onSaved: (value) => fullName = value ?? '',
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Phone Number'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter phone number'
                              : null,
                          onSaved: (value) => phoneNo = value ?? '',
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter email'
                              : null,
                          onSaved: (value) => email = value ?? '',
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Address'),
                          maxLines: 2,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter address'
                              : null,
                          onSaved: (value) => address = value ?? '',
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: addCustomer,
                          child: Text('Add Customer'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Customer List',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: errorMessage != null
                        ? Center(child: Text(errorMessage!))
                        : ListView.builder(
                            itemCount: customers.length,
                            itemBuilder: (context, index) {
                              final cust = customers[index];
                              return ListTile(
                                title: Text(cust['fullName']),
                                subtitle: Text(
                                    'Phone: ${cust['phoneNo']} | Email: ${cust['email']} | Address: ${cust['address']}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteCustomer(cust['_id']),
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
