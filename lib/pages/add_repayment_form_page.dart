
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/debt.dart';
import '../models/repayment.dart';
import '../providers/debt_provider.dart';

class AddRepaymentFormPage extends StatefulWidget {
  final Debt debt;

  const AddRepaymentFormPage({super.key, required this.debt});

  @override
  State<AddRepaymentFormPage> createState() => _AddRepaymentFormPageState();
}

class _AddRepaymentFormPageState extends State<AddRepaymentFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveRepayment() {
    if (_formKey.currentState!.validate()) {
      final newRepayment = Repayment(
        id: const Uuid().v4(),
        amount: double.parse(_amountController.text),
        date: DateTime.now(),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      Provider.of<DebtProvider>(context, listen: false)
          .addRepayment(widget.debt.id, newRepayment);
      Navigator.of(context).pop(); // Pop the form page
      Navigator.of(context).pop(); // Pop the select debt page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Rembourser ${widget.debt.personName}'),
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
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Montant du remboursement',
                        prefixIcon: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.secondary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'Montant invalide.';
                        }
                        if (double.parse(value) > widget.debt.remainingAmount) {
                          return 'Le montant ne peut pas dépasser le solde restant (${widget.debt.remainingAmount.toStringAsFixed(2)} Fcfa).';
                        }
                        return null;
                      },
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
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes (optionnel)',
                        prefixIcon: Icon(Icons.note, color: Theme.of(context).colorScheme.secondary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                        ),
                      ),
                      maxLines: 3,
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
          onPressed: _saveRepayment,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}