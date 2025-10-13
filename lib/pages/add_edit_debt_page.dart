import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/debt.dart';
import '../providers/debt_provider.dart';
import 'package:intl/intl.dart';

class AddEditDebtPage extends StatefulWidget {
  final Debt? debt;

  const AddEditDebtPage({super.key, this.debt});

  @override
  _AddEditDebtPageState createState() => _AddEditDebtPageState();
}

class _AddEditDebtPageState extends State<AddEditDebtPage> {
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
      _isOwedToMe = false; // Par défaut, c'est une dette que je dois
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.debt == null ? 'Ajouter une dette' : 'Modifier la dette'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: _personName,
                      decoration: InputDecoration(
                        labelText: 'Nom de la personne',
                        prefixIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.secondary),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un nom.';
                        }
                        return null;
                      },
                      onSaved: (value) => _personName = value!,
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: _totalAmount != 0 ? _totalAmount.toString() : '',
                      decoration: InputDecoration(
                        labelText: 'Montant total',
                        prefixIcon: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.secondary),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'Veuillez entrer un montant valide.';
                        }
                        return null;
                      },
                      onSaved: (value) => _totalAmount = double.parse(value!),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: _description,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description, color: Theme.of(context).colorScheme.secondary),
                      ),
                      maxLines: 3,
                      onSaved: (value) => _description = value ?? '',
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _dueDateController,
                      decoration: InputDecoration(
                        labelText: 'Date d\'échéance',
                        prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.secondary),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit_calendar),
                          onPressed: () => _selectDueDate(context),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: SwitchListTile(
                      title: const Text('On me doit cet argent'),
                      value: _isOwedToMe,
                      onChanged: (bool value) {
                        setState(() {
                          _isOwedToMe = value;
                        });
                      },
                      activeColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: _saveForm,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
