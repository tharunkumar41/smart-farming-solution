import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class CommodityScreen extends StatefulWidget {
  @override
  _CommodityScreenState createState() => _CommodityScreenState();
}

class _CommodityScreenState extends State<CommodityScreen> {
  Map<String, dynamic>? commodityData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String commodityName =
        ModalRoute.of(context)?.settings.arguments as String? ?? '';
    if (commodityName.isNotEmpty) {
      fetchCommodityData(commodityName);
    } else {
      setState(() {
        errorMessage = 'No commodity selected';
        isLoading = false;
      });
    }
  }

  Future<void> fetchCommodityData(String name) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final response = await ApiService.get('/api/commodity/$name');
      setState(() {
        commodityData = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load commodity data: $e';
        isLoading = false;
      });
    }
  }

  Widget buildDetailTable() {
    if (commodityData == null) return SizedBox.shrink();
    return Table(
      columnWidths: {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
      children: [
        TableRow(children: [
          Text('Current Price', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('₹ ${commodityData!['current_price']} / ql'),
        ]),
        TableRow(children: [
          Text('Prime Location', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(commodityData!['prime_loc'] ?? ''),
        ]),
        TableRow(children: [
          Text('Crop Type', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(commodityData!['type_c'] ?? ''),
        ]),
        TableRow(children: [
          Text('Export', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(commodityData!['export'] ?? ''),
        ]),
      ],
    );
  }

  Widget buildForecastTable() {
    if (commodityData == null) return SizedBox.shrink();
    final List<dynamic> forecastValues =
        commodityData!['forecast_values'] ?? [];
    return DataTable(
      columns: [
        DataColumn(label: Text('Month')),
        DataColumn(label: Text('Price (₹)')),
        DataColumn(label: Text('Change (%)')),
      ],
      rows: forecastValues.map((item) {
        final month = item[0] ?? '';
        final price = item[1] ?? '';
        final change = item[2] ?? 0;
        final isGain = (change is num && change >= 0);
        return DataRow(cells: [
          DataCell(Text(month)),
          DataCell(Text('₹$price')),
          DataCell(Row(
            children: [
              Text('$change%'),
              SizedBox(width: 4),
              Icon(
                isGain ? Icons.arrow_upward : Icons.arrow_downward,
                color: isGain ? Colors.green : Colors.red,
                size: 20,
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  LineChartData buildLineChartData(
      List<dynamic> xLabels, List<dynamic> yValues) {
    List<FlSpot> spots = [];
    for (int i = 0; i < xLabels.length && i < yValues.length; i++) {
      double y = 0;
      if (yValues[i] is num) {
        y = (yValues[i] as num).toDouble();
      } else if (yValues[i] is String) {
        y = double.tryParse(yValues[i]) ?? 0;
      }
      spots.add(FlSpot(i.toDouble(), y));
    }
    return LineChartData(
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index < 0 || index >= xLabels.length) return Container();
              return Text(xLabels[index].toString(),
                  style: TextStyle(
                      fontSize: 10, color: AppTheme.primaryDarkColor));
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, interval: 200),
        ),
      ),
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppTheme.primaryColor,
          barWidth: 3,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }

  Widget buildChart(
      String title, List<dynamic> xLabels, List<dynamic> yValues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(buildLineChartData(xLabels, yValues)),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Commodity Details'),
            backgroundColor: AppTheme.primaryColor),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Commodity Details'),
            backgroundColor: AppTheme.primaryColor),
        body: Center(
            child: Text(errorMessage!, style: TextStyle(color: Colors.red))),
      );
    }
    if (commodityData == null) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Commodity Details'),
            backgroundColor: AppTheme.primaryColor),
        body: Center(child: Text('No data available')),
      );
    }

    final minCrop = commodityData!['min_crop'] ?? ['', ''];
    final maxCrop = commodityData!['max_crop'] ?? ['', ''];
    final forecastValues = commodityData!['forecast_values'] ?? [];
    final previousValues = commodityData!['previous_values'] ?? [];

    final forecastX = forecastValues.map((e) => e[0]).toList();
    final forecastY = forecastValues.map((e) => e[1]).toList();
    final previousX = previousValues.map((e) => e[0]).toList();
    final previousY = previousValues.map((e) => e[1]).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Commodity: ${commodityData!['name'] ?? ''}'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (commodityData!['image_url'] != null)
              Center(
                child: Image.network(
                  commodityData!['image_url'],
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            SizedBox(height: 16),
            buildDetailTable(),
            SizedBox(height: 16),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text('Brief Forecast',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDarkColor)),
                    SizedBox(height: 8),
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2)
                      },
                      children: [
                        TableRow(children: [
                          Text('Min. crop price time',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(minCrop[0] ?? ''),
                          Text('₹${minCrop[1] ?? ''}'),
                        ]),
                        TableRow(children: [
                          Text('Max. crop price time',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(maxCrop[0] ?? ''),
                          Text('₹${maxCrop[1] ?? ''}'),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            buildForecastTable(),
            SizedBox(height: 16),
            buildChart('Forecast Price Trend', forecastX, forecastY),
            SizedBox(height: 16),
            buildChart('Previous Year Price Trend', previousX, previousY),
          ],
        ),
      ),
    );
  }
}
