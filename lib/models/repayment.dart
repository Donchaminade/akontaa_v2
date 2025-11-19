class Repayment {
  final String id;
  final double amount;
  final DateTime date;
  final String? notes; // Notes ou description du paiement
  final String paymentMethod;
  final String? proofImagePath;

  Repayment({
    required this.id,
    required this.amount,
    required this.date,
    this.notes,
    required this.paymentMethod,
    this.proofImagePath,
  });

  // Méthodes de sérialisation/désérialisation JSON
  factory Repayment.fromJson(Map<String, dynamic> json) {
    return Repayment(
      id: json['id'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      paymentMethod: json['paymentMethod'],
      proofImagePath: json['proofImagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'notes': notes,
      'paymentMethod': paymentMethod,
      'proofImagePath': proofImagePath,
    };
  }
}
