import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> topGainers = [];
  List<dynamic> topLosers = [];
  bool isLoading = true;
  String? errorMessage;

  final List<String> commodities = [
    "bajra",
    "barley",
    "jowar",
    "maize",
    "paddy",
    "ragi",
    "wheat",
    "betelnut_arceanut",
    "black_pepper",
    "cardamom",
    "chillies_dry",
    "coriander",
    "cumin",
    "garlic",
    "ginger_dry",
    "tamarind",
    "turmeric",
    "coir_fibre",
    "mesta",
    "raw_cotton",
    "raw_jute",
    "raw_silk",
    "raw_wool",
    "jasmine",
    "marigold",
    "rose",
    "almonds",
    "amla",
    "apple",
    "banana",
    "cashew_nut",
    "coconut_fresh",
    "grapes",
    "guava",
    "jackfruit",
    "lemon",
    "sweet_orange",
    "orange",
    "papaya",
    "pear",
    "pineapple",
    "pomengranate",
    "sapota",
    "walnut",
    "fodder",
    "gaur_seed",
    "industrial_wood",
    "raw_rubber",
    "tobacco",
    "castor_seed",
    "copra_coconut",
    "cotton_seed",
    "gingelly_seed_sesamum",
    "groundnut_seed",
    "linseed",
    "niger_seed",
    "rape_mustard_seed",
    "safflower_kardi_seed",
    "soyabean",
    "sunflower",
    "betel_leaves",
    "coffee",
    "honey",
    "sugarcane",
    "tea",
    "arhar",
    "gram",
    "masur",
    "moong",
    "peas_chawali",
    "rajma",
    "urad",
    "cotton_yarn",
    "woollen_yarn",
    "beans",
    "bittergourd",
    "bottlegourd",
    "brinjal",
    "cabbage",
    "carrot",
    "cauliflower",
    "cucumber",
    "drumstick",
    "gingerfresh",
    "ladyfinger",
    "onion",
    "peasgreen",
    "pointedgourd",
    "potato",
    "pumpkin",
    "radish",
    "sweetpotato",
    "tapioca",
    "tomato"
  ];

  String? selectedCommodity;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final top5 = await ApiService.get('/api/top5');
      final bottom5 = await ApiService.get('/api/bottom5');
      setState(() {
        topGainers = top5 ?? [];
        topLosers = bottom5 ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void onCommoditySelected(String? commodity) {
    setState(() {
      selectedCommodity = commodity;
    });
  }

  void redirectToCommodityPage() {
    if (selectedCommodity != null && selectedCommodity!.isNotEmpty) {
      Navigator.pushNamed(context, '/commodity', arguments: selectedCommodity);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a commodity from the dropdown.')),
      );
    }
  }

  Widget buildDataTable(List<dynamic> data) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Crop')),
        DataColumn(label: Text('Price (₹)')),
        DataColumn(label: Text('Change (%)')),
      ],
      rows: data.map((crop) {
        final changeStr = crop[2]?.toString() ?? '0';
        final change = double.tryParse(changeStr) ?? 0.0;
        final icon = change >= 0 ? Icons.arrow_upward : Icons.arrow_downward;
        final iconColor = change >= 0 ? Colors.green : Colors.red;
        return DataRow(cells: [
          DataCell(Text(crop[0] ?? '')),
          DataCell(Text('₹${crop[1] ?? ''}')),
          DataCell(Row(
            children: [
              Text('${change.toString()}%'),
              Icon(icon, color: iconColor, size: 16),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  Widget buildCommodityGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: commodities.map((name) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/commodity', arguments: name);
          },
          child: Card(
            margin: EdgeInsets.all(8),
            child: Center(
              child:
                  Text(name.replaceAll('_', ' '), textAlign: TextAlign.center),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Row(
                children: [
                  Image.network(
                    'https://img.icons8.com/color/48/000000/wheat.png',
                    width: 48,
                    height: 48,
                  ),
                  SizedBox(width: 8),
                  Text('Farm Inventory',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              selected: ModalRoute.of(context)?.settings.name ==
                  '/inventory-dashboard',
              onTap: () {
                Navigator.pushNamed(context, '/inventory-dashboard');
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory_2),
              title: Text('Products'),
              selected: ModalRoute.of(context)?.settings.name ==
                  '/inventory-products',
              onTap: () {
                Navigator.pushNamed(context, '/inventory-products');
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              selected: ModalRoute.of(context)?.settings.name ==
                  '/inventory-categories',
              onTap: () {
                Navigator.pushNamed(context, '/inventory-categories');
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Customers'),
              selected: ModalRoute.of(context)?.settings.name ==
                  '/inventory-customers',
              onTap: () {
                Navigator.pushNamed(context, '/inventory-customers');
              },
            ),
            ListTile(
              leading: Icon(Icons.add_shopping_cart),
              title: Text('Add Sale'),
              selected:
                  ModalRoute.of(context)?.settings.name == '/inventory-sales',
              onTap: () {
                Navigator.pushNamed(context, '/inventory-sales');
              },
            ),
            // Sales Report link can be added here if implemented
            Divider(),
            ListTile(
              leading: Icon(Icons.eco),
              title: Text('Crop Recommendation'),
              selected: ModalRoute.of(context)?.settings.name ==
                  '/crop-recommendation',
              onTap: () {
                Navigator.pushNamed(context, '/crop-recommendation');
              },
            ),
            ListTile(
              leading: Icon(Icons.science),
              title: Text('Fertilizer Recommendation'),
              selected: ModalRoute.of(context)?.settings.name ==
                  '/fertilizer-recommendation',
              onTap: () {
                Navigator.pushNamed(context, '/fertilizer-recommendation');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Clear navigation stack and navigate to login page
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/inventory-login', (Route<dynamic> route) => false);
              },
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('© 2025 SmartFarming',
                  style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Error: $errorMessage'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Top Five Gainers',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      buildDataTable(topGainers),
                      SizedBox(height: 16),
                      Text('Top Five Losers',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      buildDataTable(topLosers),
                      SizedBox(height: 16),
                      Text('Explore Commodities',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCommodity,
                              hint: Text('Select a commodity...'),
                              items: commodities.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.replaceAll('_', ' ')),
                                );
                              }).toList(),
                              onChanged: onCommoditySelected,
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: redirectToCommodityPage,
                            child: Text('Search'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      buildCommodityGrid(),
                    ],
                  ),
                ),
    );
  }
}
