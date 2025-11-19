import 'package:akontaa/l10n/app_localizations.dart';
import 'package:akontaa/pages/add_edit_event_page.dart';
import 'package:akontaa/pages/event_detail_page.dart';
import 'package:akontaa/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsListPage extends StatelessWidget {
  const EventsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.events;

    return events.isEmpty
        ? Center(
            child: Text(
              localizations.aucunEvenementPourLeMoment,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(event.name),
                  subtitle: Text(
                      "${localizations.coutTotal}: ${event.totalCost.toStringAsFixed(2)} Fcfa"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            EventDetailPage(eventId: event.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
