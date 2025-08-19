import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';

class InventorySignupScreen extends StatefulWidget {
  @override
  _InventorySignupScreenState createState() => _InventorySignupScreenState();
}

class _InventorySignupScreenState extends State<InventorySignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  bool isLoading = false;
  String? message;
  Color messageColor = Colors.red;
  bool _obscurePassword = true;

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
      message = null;
    });

    try {
      final response = await ApiService.post('/api/inventory/auth/register', {
        'username': username,
        'password': password,
      });
      setState(() {
        message = 'User created successfully. You can now login.';
        messageColor = Colors.green;
      });
      _formKey.currentState!.reset();
    } catch (e) {
      setState(() {
        message = 'Signup failed: ${e.toString()}';
        messageColor = Colors.red;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Signup'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (message != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Text(
                          message!,
                          style: TextStyle(color: messageColor),
                        ),
                      ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter username'
                          : null,
                      onSaved: (value) => username = value ?? '',
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter password'
                          : null,
                      onSaved: (value) => password = value ?? '',
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        minimumSize: Size(double.infinity, 48),
                      ),
                      onPressed: signup,
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
