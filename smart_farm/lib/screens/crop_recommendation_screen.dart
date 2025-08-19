import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class CropRecommendationScreen extends StatefulWidget {
  @override
  _CropRecommendationScreenState createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'N': TextEditingController(),
    'P': TextEditingController(),
    'K': TextEditingController(),
    'temperature': TextEditingController(),
    'humidity': TextEditingController(),
    'ph': TextEditingController(),
    'rainfall': TextEditingController(),
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
      'N': _controllers['N']!.text,
      'P': _controllers['P']!.text,
      'K': _controllers['K']!.text,
      'temperature': _controllers['temperature']!.text,
      'humidity': _controllers['humidity']!.text,
      'ph': _controllers['ph']!.text,
      'rainfall': _controllers['rainfall']!.text,
    };

    try {
      final response = await ApiService.post('/predict', formData);
      setState(() {
        _result = response['crop'] ?? 'No prediction';
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
        title: Text('Crop Recommendation'),
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
                  _buildTextField('Nitrogen (N)', 'N'),
                  _buildTextField('Phosphorus (P)', 'P'),
                  _buildTextField('Potassium (K)', 'K'),
                  _buildTextField('Temperature (°C)', 'temperature'),
                  _buildTextField('Humidity (%)', 'humidity'),
                  _buildTextField('pH Level', 'ph'),
                  _buildTextField('Rainfall (mm)', 'rainfall'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      minimumSize: Size(double.infinity, 48),
                    ),
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Predict Crop'),
                  ),
                  SizedBox(height: 20),
                  if (_result != null)
                    Text(
                      'Predicted Crop: $_result',
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
