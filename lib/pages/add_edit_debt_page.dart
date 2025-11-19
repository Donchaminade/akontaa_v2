import 'package:akontaa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/debt.dart';
import '../providers/debt_provider.dart';
import 'package:intl/intl.dart';

class AddEditDebtPage extends StatefulWidget {
  final Debt? debt;
  final bool isOwedToMe;

  const AddEditDebtPage({super.key, this.debt, this.isOwedToMe = false});

  @override
  AddEditDebtPageState createState() => AddEditDebtPageState();
}

class AddEditDebtPageState extends State<AddEditDebtPage> {
  final _formKey = GlobalKey<FormState>();
  late String _personName;
  late double _totalAmount;
  late String _description;
  late DateTime _dueDate;
  late bool _isOwedToMe;

  final _dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final debt = widget.debt;
    if (debt != null) {
      _personName = debt.personName;
      _totalAmount = debt.totalAmount;
      _description = debt.description;
      _dueDate = debt.dueDate;
      _isOwedToMe = debt.isOwedToMe;
    } else {
      _personName = '';
      _totalAmount = 0.0;
      _description = '';
      _dueDate = DateTime.now();
      _isOwedToMe = widget.isOwedToMe;
    }
    _dueDateController.text = DateFormat('dd/MM/yyyy').format(_dueDate);
  }

  @override
  void dispose() {
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.secondary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('dd/MM/yyyy').format(_dueDate);
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final debtProvider = Provider.of<DebtProvider>(context, listen: false);

      final debtToSave = Debt(
        id: widget.debt?.id ?? const Uuid().v4(),
        personName: _personName,
        totalAmount: _totalAmount,
        description: _description,
        dueDate: _dueDate,
        isOwedToMe: _isOwedToMe,
        repayments: widget.debt?.repayments ?? [],
      );

      if (widget.debt == null) {
        debtProvider.addDebt(debtToSave);
      } else {
        debtProvider.updateDebt(debtToSave);
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
        title: Text(widget.debt == null
            ? localizations.ajouterUneDette
            : localizations.modifierLaDette),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CustomCard(
                  child: TextFormField(
                    initialValue: _personName,
                    decoration: _buildInputDecoration(
                        localizations.nomDeLaPersonne, Icons.person, context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.veuillezEntrerUnNom;
                      }
                      return null;
                    },
                    onSaved: (value) => _personName = value!,
                  ),
                ),
                const SizedBox(height: 16),
                _CustomCard(
                  child: TextFormField(
                    initialValue:
                        _totalAmount != 0 ? _totalAmount.toString() : '',
                    decoration: _buildInputDecoration(
                        localizations.montantTotal, Icons.attach_money, context),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return localizations.veuillezEntrerUnMontantValide;
                      }
                      return null;
                    },
                    onSaved: (value) => _totalAmount = double.parse(value!),
                  ),
                ),
                const SizedBox(height: 16),
                _CustomCard(
                  child: TextFormField(
                    initialValue: _description,
                    decoration: _buildInputDecoration(
                        localizations.description, Icons.description, context),
                    maxLines: 3,
                    onSaved: (value) => _description = value ?? '',
                  ),
                ),
                const SizedBox(height: 16),
                _CustomCard(
                  child: TextFormField(
                    controller: _dueDateController,
                    decoration: _buildInputDecoration(
                        localizations.dateEcheance, Icons.calendar_today, context)
                        .copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.edit_calendar, color: Theme.of(context).colorScheme.secondary),
                        onPressed: () => _selectDueDate(context),
                      ),
                    ),
                    readOnly: true,
                  ),
                ),
                const SizedBox(height: 16),
                _CustomCard(
                  child: SwitchListTile(
                    title: Text(localizations.onMeDoitCetArgent, style: const TextStyle(fontSize: 16)),
                    value: _isOwedToMe,
                    onChanged: (bool value) {
                      setState(() {
                        _isOwedToMe = value;
                      });
                    },
                    activeColor: Theme.of(context).colorScheme.secondary,
                    secondary: Icon(Icons.swap_horiz, color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                const SizedBox(height: 32),
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
              ],
            ),
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
