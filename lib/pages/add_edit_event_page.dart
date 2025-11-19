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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CustomCard(
                child: TextFormField(
                  initialValue: _eventName,
                  decoration: _buildInputDecoration(
                      localizations.nomDeLEvenement, Icons.event, context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.veuillezEntrerUnNom;
                    }
                    return null;
                  },
                  onSaved: (value) => _eventName = value!,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  localizations.ajouter,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 80), // To avoid FAB overlap issue if any
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
      String label, IconData icon, BuildContext context) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.secondary),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
      ),
    );
  }
}

class _CustomCard extends StatelessWidget {
  final Widget child;
  const _CustomCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
