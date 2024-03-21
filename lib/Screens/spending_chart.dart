import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notion_budget/models/item_model.dart';

class SpendingChart extends StatelessWidget {
  final List<Item> items;
  const SpendingChart({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final spending = <String, double>{};
    items.forEach(
      (item) => spending.update(
        item.category,
        (value) => value + item.price,
        ifAbsent: () => item.price,
      ),
    );
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 360,
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: spending
                      .map(
                        (category, amountSpent) => MapEntry(
                          category,
                          PieChartSectionData(
                            color: getCategoryColor(category),
                            radius: 100.0,
                            title: '\$ ${amountSpent.toStringAsFixed(2)}',
                            value: amountSpent,
                          ),
                        ),
                      )
                      .values
                      .toList(),
                  sectionsSpace: 0,
                ),
              ),
            ),
            //a little bit hiegth
            const SizedBox(height: 20),
            //
            Wrap(
              //keys is category in database or api notion
              children: spending.keys
                  .map(
                    (category) => _Indicator(
                      color: getCategoryColor(category),
                      category: category,
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String category;

  const _Indicator({
    // ignore: unused_element
    super.key,
    required this.color,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 16.0,
          width: 16.0,
          color: getCategoryColor(category),
        ),
        const SizedBox(width: 5.0),
        Text(
          category,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 5.0),
      ],
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
