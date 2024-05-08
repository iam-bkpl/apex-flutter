import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet_app/model/transaction.dart';

class TransactionForm extends StatefulWidget {
  final void Function(WalletTransaction? newWalletTransaction)
      addWalletTransaction;

  TransactionForm({super.key, required this.addWalletTransaction});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";
  DateTime _dateTime = DateTime.now();
  double _amount = 0.0;
  TransactionType _type = TransactionType.expense; // Default transaction type

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      // Construct transaction data
      WalletTransaction transactionData = WalletTransaction.init(
          _title, _description, _amount, _dateTime, _type);

      // Trigger addTransaction function passed from parent widget
      widget.addWalletTransaction(transactionData);

      // Dismiss the form
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Transaction'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Transaction Title'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) _title = value;
                  }),
              TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Transaction Description'),
                  onSaved: (value) {
                    if (value != null) _description = value;
                  }),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Transaction Date: ${DateFormat('yyyy-MM-dd').parse(_dateTime.toString())}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _dateTime) {
                        setState(() {
                          _dateTime = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Transaction Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value)! <= 0) {
                        return 'Amount must be greater than 0';
                      }
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) _amount = double.parse(value);
                  }),
              DropdownButtonFormField(
                value: _type,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _type = value;
                    });
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: TransactionType.income,
                    child: Text('income'),
                  ),
                  DropdownMenuItem(
                    value: TransactionType.expense,
                    child: Text('expense'),
                  ),
                ],
                decoration:
                    const InputDecoration(labelText: 'Transaction Type'),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        MaterialButton(
          onPressed: _submitForm,
          child: const Text('Add Transaction'),
        ),
      ],
    );
  }
}
