import 'package:akontaa/l10n/app_localizations.dart';
import 'package:akontaa/models/event.dart';
import 'package:akontaa/pages/add_edit_event_item_page.dart';
import 'package:akontaa/pages/add_edit_event_page.dart';
import 'package:akontaa/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class EventDetailPage extends StatelessWidget {
  final String eventId;

  const EventDetailPage({super.key, required this.eventId});

  Future<void> _generatePdf(BuildContext context, Event event) async {
    final pdf = pw.Document();
    final localizations = AppLocalizations.of(context)!;
    final currencyFormat =
        NumberFormat.currency(locale: 'fr_FR', symbol: 'Fcfa');

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context pwContext) => [
          pw.Center(
            child: pw.Text(
              event.name,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(localizations.coutTotal,
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text(currencyFormat.format(event.totalCost),
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ]),
          pw.Divider(height: 20),
          pw.Text(localizations.articles,
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          ...event.items.map((item) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(item.name),
                      pw.Text(currencyFormat.format(item.cost)),
                    ]),
                pw.Text("Date: ${DateFormat('dd/MM/yyyy').format(item.date)}"),
                pw.Divider(),
              ],
            );
          }).toList(),
        ],
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: '${event.name}_details.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final event = Provider.of<EventProvider>(context).findById(eventId);
    final currencyFormat =
        NumberFormat.currency(locale: 'fr_FR', symbol: 'Fcfa');

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(event.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              _generatePdf(context, event);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditEventPage(event: event),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations.coutTotal,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      currencyFormat.format(event.totalCost),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: event.items.isEmpty
                ? Center(
                    child: Text(localizations.aucunArticleDansCetEvenement),
                  )
                : ListView.builder(
                    itemCount: event.items.length,
                    itemBuilder: (context, index) {
                      final item = event.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle:
                              Text(DateFormat('dd/MM/yyyy').format(item.date)),
                          trailing: Text(currencyFormat.format(item.cost)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditEventItemPage(eventId: eventId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
