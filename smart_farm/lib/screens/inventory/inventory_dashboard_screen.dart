import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';

class InventoryDashboardScreen extends StatefulWidget {
  @override
  _InventoryDashboardScreenState createState() =>
      _InventoryDashboardScreenState();
}

class _InventoryDashboardScreenState extends State<InventoryDashboardScreen> {
  Map<String, dynamic>? dashboardData;
  List<dynamic>? salesData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final data = await ApiService.get('/api/inventory/dashboard/overview');
      final sales = await ApiService.get('/api/inventory/dashboard/sales-data');
      setState(() {
        dashboardData = data;
        salesData = sales;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Map<String, double> groupBySum(List<dynamic> data, String key) {
    final Map<String, double> result = {};
    for (var item in data) {
      final k = item[key] ?? 'Unknown';
      final quantity = double.tryParse(item['Quantity'].toString()) ?? 0;
      result[k] = (result[k] ?? 0) + quantity;
    }
    return result;
  }

  Map<String, Map<String, double>> groupByTwoKeys(
      List<dynamic> data, String key1, String key2) {
    final Map<String, Map<String, double>> result = {};
    for (var item in data) {
      final k1 = item[key1] ?? 'Unknown';
      final k2 = item[key2] ?? 'Unknown';
      final quantity = double.tryParse(item['Quantity'].toString()) ?? 0;
      result[k1] ??= {};
      result[k1]![k2] = (result[k1]![k2] ?? 0) + quantity;
    }
    return result;
  }

  Map<String, List<double>> groupQuantitiesByProduct(List<dynamic> data) {
    final Map<String, List<double>> result = {};
    for (var item in data) {
      final product = item['Product'] ?? 'Unknown';
      final quantity = double.tryParse(item['Quantity'].toString()) ?? 0;
      result[product] ??= [];
      result[product]!.add(quantity);
    }
    return result;
  }

  Widget buildBarChart(Map<String, double> data, String title, Color color) {
    final spots = <BarChartGroupData>[];
    int i = 0;
    data.forEach((key, value) {
      spots.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
            toY: value is double ? value : value.toDouble(),
            color: color,
            width: 16),
      ]));
      i++;
    });

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (data.values.isNotEmpty)
                      ? (data.values.reduce((a, b) => a > b ? a : b) * 1.2)
                      : 10,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= data.length)
                            return Container();
                          final key = data.keys.elementAt(index);
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(key,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primaryDarkColor)),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: spots,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeatmap(
      Map<String, Map<String, double>> data, double cellSize, Color color) {
    final products = data.keys.toList();
    final customers = <String>{};
    data.values.forEach((map) => customers.addAll(map.keys));
    final customerList = customers.toList();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Product-Customer Heatmap',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: cellSize),
                      ...customerList.map((c) => Container(
                            width: cellSize,
                            height: cellSize,
                            alignment: Alignment.center,
                            child: Text(c,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primaryDarkColor)),
                          )),
                    ],
                  ),
                  ...products.map((product) {
                    return Row(
                      children: [
                        Container(
                          width: cellSize,
                          height: cellSize,
                          alignment: Alignment.centerLeft,
                          child: Text(product,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.primaryDarkColor)),
                        ),
                        ...customerList.map((customer) {
                          final value = data[product]?[customer] ?? 0;
                          final intensity = (value > 0)
                              ? (value /
                                  (data.values
                                      .expand((m) => m.values)
                                      .reduce((a, b) => a > b ? a : b)))
                              : 0;
                          final cellColor = Color.lerp(
                              Colors.white, color, intensity.toDouble())!;
                          return Container(
                            width: cellSize,
                            height: cellSize,
                            color: cellColor,
                            alignment: Alignment.center,
                            child: Text(value.toStringAsFixed(0),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primaryDarkColor)),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoxPlot(Map<String, List<double>> data) {
    // fl_chart does not support boxplot natively, so approximate with bar chart of averages
    final averages = <String, double>{};
    data.forEach((key, values) {
      if (values.isNotEmpty) {
        averages[key] = values.reduce((a, b) => a + b) / values.length;
      }
    });
    return buildBarChart(
        averages, 'Average Sales per Transaction', Colors.green[400]!);
  }

  Widget buildDashboard() {
    if (dashboardData == null) {
      return Center(
          child: Text('No data available',
              style: Theme.of(context).textTheme.bodyMedium));
    }
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text('Inventory Dashboard Summary',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            title: Text('Total Products',
                style: Theme.of(context).textTheme.bodyMedium),
            trailing: Text('${dashboardData!['totalProducts'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            title: Text('Total Categories',
                style: Theme.of(context).textTheme.bodyMedium),
            trailing: Text('${dashboardData!['totalCategories'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            title: Text('Total Customers',
                style: Theme.of(context).textTheme.bodyMedium),
            trailing: Text('${dashboardData!['totalCustomers'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            title: Text('Total Sales',
                style: Theme.of(context).textTheme.bodyMedium),
            trailing: Text('${dashboardData!['totalSales'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        if (salesData != null) ...[
          SizedBox(height: 24),
          buildBarChart(groupBySum(salesData!, 'Product'),
              'Total Sales by Product', Colors.green[400]!),
          buildBarChart(groupBySum(salesData!, 'Customer'),
              'Sales Volume by Customer', Colors.green[400]!),
          buildHeatmap(groupByTwoKeys(salesData!, 'Product', 'Customer'), 40,
              Colors.green[800]!),
          buildBoxPlot(groupQuantitiesByProduct(salesData!)),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Dashboard'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text('Error: $errorMessage',
                      style: Theme.of(context).textTheme.bodyMedium))
              : buildDashboard(),
    );
  }
}
