import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/crop_recommendation_screen.dart';
import 'screens/fertilizer_recommendation_screen.dart';
import 'screens/inventory/login_screen.dart';
import 'screens/inventory/inventory_dashboard_screen.dart';
import 'screens/inventory/products_screen.dart';
import 'screens/inventory/categories_screen.dart';
import 'screens/inventory/customers_screen.dart';
import 'screens/inventory/sales_screen.dart';
import 'screens/inventory/signup_screen.dart';
import 'screens/commodity_screen.dart';

void main() {
  runApp(FarmingSolutionApp());
}

class FarmingSolutionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lightGreen = Color(0xFFB2DFDB); // Light green shade

    return MaterialApp(
      title: 'Farming Solution',
      theme: ThemeData(
        primaryColor: lightGreen,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: lightGreen,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/inventory-login',
      routes: {
        '/': (context) => DashboardScreen(),
        '/crop-recommendation': (context) => CropRecommendationScreen(),
        '/fertilizer-recommendation': (context) =>
            FertilizerRecommendationScreen(),
        '/inventory-login': (context) => InventoryLoginScreen(),
        '/inventory-dashboard': (context) => InventoryDashboardScreen(),
        '/inventory-products': (context) => ProductsScreen(),
        '/inventory-categories': (context) => CategoriesScreen(),
        '/inventory-customers': (context) => CustomersScreen(),
        '/inventory-sales': (context) => SalesScreen(),
        '/inventory-signup': (context) => InventorySignupScreen(),
        '/commodity': (context) => CommodityScreen(),
      },
    );
  }
}
