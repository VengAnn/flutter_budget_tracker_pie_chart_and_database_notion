import 'package:flutter/material.dart';
import 'package:flutter_notion_budget/Screens/spending_chart.dart';
import 'package:flutter_notion_budget/models/failure_model.dart';
import 'package:flutter_notion_budget/models/item_model.dart';
import 'package:flutter_notion_budget/repository/budget_repository.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    // initialize _futureItem
    _futureItems = BudgetRepository().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Tracker"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _futureItems = BudgetRepository().getItems();
          setState(() {});
        },
        child: FutureBuilder(
          future: _futureItems,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // show pie chart and listview item
              final items = snapshot.data!;
              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    if (index == 0) return SpendingChart(items: items);

                    final item = items[index - 1];
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color: getCategoryColor(item.category),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                            '${item.category} ${DateFormat.yMd().format(item.date)}'),
                        // ignore: unnecessary_string_interpolations
                        trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              // show failure error message
              final failure = snapshot.error as Failure;
              return Center(child: Text(failure.message));
            }
            // show a loading spinner
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

//
Color getCategoryColor(String category) {
  switch (category) {
    case 'Entertainment':
      return Colors.red[400]!;
    case 'Food':
      return Colors.brown[400]!;
    case 'Personal':
      return Colors.blue[400]!;
    case 'Transportation':
      return Colors.purple[400]!;
    default:
      return Colors.orange[400]!;
  }
}
