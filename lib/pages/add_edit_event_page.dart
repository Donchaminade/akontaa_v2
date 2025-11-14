import 'package:akontaa/l10n/app_localizations.dart';
import 'package:akontaa/models/event.dart';
import 'package:akontaa/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddEditEventPage extends StatefulWidget {
  final Event? event;

  const AddEditEventPage({super.key, this.event});

  @override
  State<AddEditEventPage> createState() => _AddEditEventPageState();
}

class _AddEditEventPageState extends State<AddEditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late String _eventName;

  @override
  void initState() {
    super.initState();
    _eventName = widget.event?.name ?? '';
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final eventProvider = Provider.of<EventProvider>(context, listen: false);

      final eventToSave = Event(
        id: widget.event?.id ?? const Uuid().v4(),
        name: _eventName,
        items: widget.event?.items ?? [],
      );

      if (widget.event == null) {
        eventProvider.addEvent(eventToSave);
      } else {
        eventProvider.updateEvent(eventToSave);
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
        title: Text(widget.event == null
            ? localizations.ajouterUnEvenement
            : localizations.modifierUnEvenement),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            initialValue: _eventName,
            decoration: InputDecoration(
              labelText: localizations.nomDeLEvenement,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localizations.veuillezEntrerUnNom;
              }
              return null;
            },
            onSaved: (value) => _eventName = value!,
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
