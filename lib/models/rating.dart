class Rating {
  final String userEmail;
  final double value;

  Rating({required this.userEmail, required this.value});

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'value': value,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> data) {
    return Rating(
      userEmail: data['userEmail'] ?? '',
      value: (data['value'] ?? 0).toDouble(),
    );
  }
}
