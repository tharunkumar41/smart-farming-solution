import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class FertilizerRecommendationScreen extends StatefulWidget {
  @override
  _FertilizerRecommendationScreenState createState() =>
      _FertilizerRecommendationScreenState();
}

class _FertilizerRecommendationScreenState
    extends State<FertilizerRecommendationScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'soilType': TextEditingController(),
    'cropType': TextEditingController(),
    'nitrogen': TextEditingController(),
    'phosphorous': TextEditingController(),
    'potassium': TextEditingController(),
  };

  String? _result;
  bool _isLoading = false;

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    final formData = {
      'soilType': _controllers['soilType']!.text,
      'cropType': _controllers['cropType']!.text,
      'nitrogen': _controllers['nitrogen']!.text,
      'phosphorous': _controllers['phosphorous']!.text,
      'potassium': _controllers['potassium']!.text,
    };

    try {
      final response = await ApiService.post('/predict-fertilizer', formData);
      setState(() {
        _result = response['fertilizer'] ?? 'No recommendation';
      });
    } catch (e) {
      setState(() {
        _result = "Error occurred: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[key],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fertilizer Recommendation'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField(
                      'Soil Type (0 = Sandy, 1 = Loamy, ...)', 'soilType'),
                  _buildTextField(
                      'Crop Type (0 = Maize, 1 = Sugarcane, ...)', 'cropType'),
                  _buildTextField('Nitrogen (N)', 'nitrogen'),
                  _buildTextField('Phosphorous (P)', 'phosphorous'),
                  _buildTextField('Potassium (K)', 'potassium'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      minimumSize: Size(double.infinity, 48),
                    ),
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Predict Fertilizer'),
                  ),
                  SizedBox(height: 20),
                  if (_result != null)
                    Text(
                      'Recommended Fertilizer: $_result',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkColor),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
