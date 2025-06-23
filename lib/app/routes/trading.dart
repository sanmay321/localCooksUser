import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TradingSimulatorScreen extends StatefulWidget {
  @override
  _TradingSimulatorState createState() => _TradingSimulatorState();
}

class _TradingSimulatorState extends State<TradingSimulatorScreen> {
  double virtualBalance = 10000.0;
  List<Trade> trades = [];
  Map<String, num> stockPrices = {};

  Future<void> fetchStockPrice(String symbol) async {
    final url = 'https://finnhub.io/api/v1/quote?symbol=$symbol&token=cvjcha1r01qlscpb8q80cvjcha1r01qlscpb8q8g';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        if(data['c'] is double){
          stockPrices[symbol] = data['c'] ?? 0.0;
        }else{
          stockPrices[symbol] = data['c'].toDouble();
        }
      });
    }
  }

  void _buyStock(String symbol, num price) {
    if (virtualBalance >= price) {
      setState(() {
        virtualBalance -= price;
        trades.add(Trade(symbol: symbol, price: price));
      });
    }
  }

  void _showBuyDialog() {
    String symbol = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buy Stock'),
        content: TextField(
          decoration: InputDecoration(labelText: 'Stock Symbol (e.g., AAPL)'),
          onChanged: (value) => symbol = value.toUpperCase(),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Get Price'),
            onPressed: () async {
              await fetchStockPrice(symbol);
              num price = 0;
              if(price is double){
                price = stockPrices[symbol] ?? 0.0;
              }else{
                price = stockPrices[symbol]?.toDouble() ?? 0.0;
              }
              if (price > 0) {
                _buyStock(symbol, price);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showWhatIfDialog() {
    String symbol = '';
    double pastPrice = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('What-If Scenario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Stock Symbol'),
              onChanged: (value) => symbol = value.toUpperCase(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Price 1 Month Ago (AED)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => pastPrice = double.tryParse(value) ?? 0,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Simulate'),
            onPressed: () async {
              await fetchStockPrice(symbol);
              final currentPrice = stockPrices[symbol] ?? 0;
              if (pastPrice > 0 && currentPrice > 0) {
                final shares = virtualBalance / pastPrice;
                final newBalance = shares * currentPrice;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('What-If Result'),
                    content: Text('If you had invested all AED ${virtualBalance.toStringAsFixed(2)} in $symbol at AED ${pastPrice.toStringAsFixed(2)}, you would now have AED ${newBalance.toStringAsFixed(2)}.'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTradeList() {
    return ListView.builder(
      itemCount: trades.length,
      itemBuilder: (context, index) {
        final trade = trades[index];
        return ListTile(
          title: Text(trade.symbol),
          subtitle: Text('Bought at: AED ${trade.price.toStringAsFixed(2)}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kids Trading Simulator'),
        actions: [
          IconButton(
            icon: Icon(Icons.question_mark),
            tooltip: 'What-If',
            onPressed: _showWhatIfDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Virtual Balance: AED ${virtualBalance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: _buildTradeList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBuyDialog,
        child: Icon(Icons.add),
        tooltip: 'Buy Stock',
      ),
    );
  }
}

class Trade {
  final String symbol;
  final num price;

  Trade({required this.symbol, required this.price});
}