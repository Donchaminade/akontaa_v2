class EventItem {
  String id;
  String name;
  double cost;
  DateTime date;

  EventItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.date,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'date': date.toIso8601String(),
    };
  }
}
