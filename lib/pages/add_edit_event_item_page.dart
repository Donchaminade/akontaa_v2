import 'package:akontaa/l10n/app_localizations.dart';
import 'package:akontaa/models/event_item.dart';
import 'package:akontaa/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddEditEventItemPage extends StatefulWidget {
  final String eventId;
  final EventItem? item;

  const AddEditEventItemPage({super.key, required this.eventId, this.item});

  @override
  State<AddEditEventItemPage> createState() => _AddEditEventItemPageState();
}

class _AddEditEventItemPageState extends State<AddEditEventItemPage> {
  final _formKey = GlobalKey<FormState>();
  late String _itemName;
  late double _itemCost;

  @override
  void initState() {
    super.initState();
    _itemName = widget.item?.name ?? '';
    _itemCost = widget.item?.cost ?? 0.0;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final eventProvider = Provider.of<EventProvider>(context, listen: false);

      final itemToSave = EventItem(
        id: widget.item?.id ?? const Uuid().v4(),
        name: _itemName,
        cost: _itemCost,
        date: DateTime.now(),
      );

      if (widget.item == null) {
        eventProvider.addEventItem(widget.eventId, itemToSave);
      } else {
        eventProvider.updateEventItem(widget.eventId, itemToSave);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.item == null
            ? localizations.ajouterUnArticle
            : localizations.modifierUnArticle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _itemName,
                decoration: InputDecoration(
                  labelText: localizations.nomDeLArticle,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.veuillezEntrerUnNom;
                  }
                  return null;
                },
                onSaved: (value) => _itemName = value!,
              ),
              TextFormField(
                initialValue: _itemCost != 0 ? _itemCost.toString() : '',
                decoration: InputDecoration(
                  labelText: localizations.cout,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return localizations.veuillezEntrerUnCoutValide;
                  }
                  return null;
                },
                onSaved: (value) => _itemCost = double.parse(value!),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveForm,
        child: const Icon(Icons.save),
      ),
    );
  }
}
