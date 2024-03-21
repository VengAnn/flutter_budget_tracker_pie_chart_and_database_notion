class Item {
  final String name;
  final String category;
  final double price;
  final DateTime date;

  const Item({
    required this.name,
    required this.category,
    required this.price,
    required this.date,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    final nameList = (properties['Name']?['title'] ?? []) as List;
    final dateStr = properties['Date']?['date']?['start'];

    // Extracting price from rich text
    final priceRichText = properties['Price']?['rich_text'] as List<dynamic>;
    String priceContent =
        priceRichText.isNotEmpty ? priceRichText[0]['text']['content'] : '0';
    double price = double.tryParse(priceContent) ?? 0;

    return Item(
      name: nameList.isNotEmpty ? nameList[0]['plain_text'] : '?',
      category: properties['Category']?['select']?['name'] ?? 'Any',
      price: price,
      date: dateStr != null ? DateTime.parse(dateStr) : DateTime.now(),
    );
  }
}
