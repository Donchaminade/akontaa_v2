import 'package:akontaa/models/event_item.dart';

class Event {
  String id;
  String name;
  List<EventItem> items;

  Event({
    required this.id,
    required this.name,
    List<EventItem>? items,
  }) : items = items ?? [];

  double get totalCost {
    return items.fold(0.0, (sum, item) => sum + item.cost);
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List? ?? [];
    List<EventItem> items =
        itemsList.map((i) => EventItem.fromJson(i)).toList();

    return Event(
      id: json['id'],
      name: json['name'],
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
