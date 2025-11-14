class Repayment {
  final String id;
  final double amount;
  final DateTime date;
  final String? notes; // Notes ou description du paiement

  Repayment({
    required this.id,
    required this.amount,
    required this.date,
    this.notes,
  });

  // Méthodes de sérialisation/désérialisation JSON
  factory Repayment.fromJson(Map<String, dynamic> json) {
    return Repayment(
      id: json['id'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
}
