import 'dart:io';

import 'package:akontaa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

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

  DateTime _paymentDate = DateTime.now();
  String? _paymentMethod;
  XFile? _proofImage;

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

  void _selectDate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 400,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is DateTime) {
                  setState(() {
                    _paymentDate = args.value;
                  });
                  Navigator.of(context).pop();
                }
              },
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: _paymentDate,
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _proofImage = pickedImage;
    });
  }

  void _saveRepayment() async {
    final localizations = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      if (_paymentMethod == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.veuillezSelectionnerMethodePaiement),
          ),
        );
        return;
      }

      String? proofImagePath;
      if (_proofImage != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = p.basename(_proofImage!.path);
        final savedImage =
            await File(_proofImage!.path).copy('${appDir.path}/$fileName');
        proofImagePath = savedImage.path;
      }

      final newRepayment = Repayment(
        id: const Uuid().v4(),
        amount: double.parse(_amountController.text),
        date: _paymentDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        paymentMethod: _paymentMethod!,
        proofImagePath: proofImagePath,
      );
      Provider.of<DebtProvider>(context, listen: false)
          .addRepayment(widget.debt.id, newRepayment);
      Navigator.of(context).pop(); // Pop the form page
      Navigator.of(context).pop(); // Pop the select debt page
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final paymentMethods = [
      localizations.especes,
      localizations.virementBancaire,
      localizations.paiementMobile,
      localizations.cheque,
    ];

    if (_paymentMethod == null) {
      _paymentMethod = paymentMethods.first;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(localizations.rembourserPerson(widget.debt.personName)),
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
                // Amount
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: localizations.montantDuRemboursement,
                        prefixIcon: Icon(Icons.attach_money,
                            color: Theme.of(context).colorScheme.secondary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return localizations.montantInvalide;
                        }
                        if (double.parse(value) > widget.debt.remainingAmount) {
                          return localizations
                              .leMontantNePeutPasDepasserLeSoldeRestant(widget
                                  .debt.remainingAmount
                                  .toStringAsFixed(2));
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                // Payment Method
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField<String>(
                      value: _paymentMethod,
                      items: paymentMethods
                          .map((method) => DropdownMenuItem(
                                value: method,
                                child: Text(method),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: localizations.methodeDePaiement,
                        prefixIcon: Icon(Icons.payment,
                            color: Theme.of(context).colorScheme.secondary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                // Date Picker
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      leading: Icon(Icons.calendar_today,
                          color: Theme.of(context).colorScheme.secondary),
                      title: Text(localizations.dateDePaiement),
                      subtitle:
                          Text(DateFormat.yMd().add_jms().format(_paymentDate)),
                      onTap: _selectDate,
                    ),
                  ),
                ),
                // Image Picker
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.camera_alt,
                              color: Theme.of(context).colorScheme.secondary),
                          title: Text(localizations.preuvePhoto),
                          onTap: _pickImage,
                        ),
                        if (_proofImage != null)
                          Image.file(
                            File(_proofImage!.path),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                      ],
                    ),
                  ),
                ),
                // Notes
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: localizations.notesOptionnel,
                        prefixIcon: Icon(Icons.note,
                            color: Theme.of(context).colorScheme.secondary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2),
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
