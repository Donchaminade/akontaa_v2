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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CustomCard(
                child: TextFormField(
                  initialValue: _itemName,
                  decoration: _buildInputDecoration(
                      localizations.nomDeLArticle, Icons.shopping_cart, context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.veuillezEntrerUnNom;
                    }
                    return null;
                  },
                  onSaved: (value) => _itemName = value!,
                ),
              ),
              const SizedBox(height: 16),
              _CustomCard(
                child: TextFormField(
                  initialValue: _itemCost != 0 ? _itemCost.toString() : '',
                  decoration: _buildInputDecoration(
                      localizations.cout, Icons.attach_money, context),
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
              const SizedBox(height: 80),
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
