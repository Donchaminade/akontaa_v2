import 'repayment.dart';

class Debt {
  String id;
  String personName;
  double totalAmount;
  String description;
  DateTime dueDate;
  bool isOwedToMe; // true si on me doit de l'argent, false si je dois de l'argent
  List<Repayment> repayments;

  Debt({
    required this.id,
    required this.personName,
    required this.totalAmount,
    required this.description,
    required this.dueDate,
    this.isOwedToMe = false,
    List<Repayment>? repayments,
  }) : repayments = repayments ?? [];

  double get remainingAmount {
    final repaid = repayments.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    return totalAmount - repaid;
  }

  bool get isPaid {
    return remainingAmount <= 0;
  }

  // Méthodes de sérialisation/désérialisation JSON
  factory Debt.fromJson(Map<String, dynamic> json) {
    var repaymentsList = json['repayments'] as List? ?? [];
    List<Repayment> repayments =
        repaymentsList.map((i) => Repayment.fromJson(i)).toList();

    return Debt(
      id: json['id'],
      personName: json['personName'],
      totalAmount: json['totalAmount'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isOwedToMe: json['isOwedToMe'] ?? false,
      repayments: repayments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personName': personName,
      'totalAmount': totalAmount,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isOwedToMe': isOwedToMe,
      'repayments': repayments.map((r) => r.toJson()).toList(),
    };
  }
}