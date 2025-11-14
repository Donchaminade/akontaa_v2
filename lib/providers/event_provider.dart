import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import '../models/event_item.dart';
import '../services/storage_service.dart';

class EventProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Event> _events = [];

  List<Event> get events => [..._events];

  Event findById(String id) {
    return _events.firstWhere((event) => event.id == id);
  }

  Future<void> loadEvents() async {
    _events = await _storageService.loadEvents();
    notifyListeners();
  }

  Future<void> _saveEvents() async {
    await _storageService.saveEvents(_events);
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    _events.add(event);
    await _saveEvents();
  }

  Future<void> updateEvent(Event updatedEvent) async {
    final index = _events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      await _saveEvents();
    }
  }

  Future<void> deleteEvent(String id) async {
    _events.removeWhere((event) => event.id == id);
    await _saveEvents();
  }

  Future<void> addEventItem(String eventId, EventItem item) async {
    final event = findById(eventId);
    event.items.add(item);
    await _saveEvents();
  }

  Future<void> updateEventItem(String eventId, EventItem updatedItem) async {
    final event = findById(eventId);
    final itemIndex =
        event.items.indexWhere((item) => item.id == updatedItem.id);
    if (itemIndex != -1) {
      event.items[itemIndex] = updatedItem;
      await _saveEvents();
    }
  }

  Future<void> deleteEventItem(String eventId, String itemId) async {
    final event = findById(eventId);
    event.items.removeWhere((item) => item.id == itemId);
    await _saveEvents();
  }

  Future<void> clearAllEvents() async {
    _events.clear();
    await _saveEvents();
  }
}
