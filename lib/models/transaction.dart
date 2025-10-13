enum TransactionType { debt, repayment }

class Transaction {
  final dynamic item;
  final TransactionType type;
  final DateTime date;

  Transaction({required this.item, required this.type, required this.date});
}
