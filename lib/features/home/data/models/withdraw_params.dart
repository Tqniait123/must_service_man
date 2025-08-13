class WithdrawParams {
  final String requestedPoints;
  final String note;

  WithdrawParams({required this.requestedPoints, required this.note});

  Map<String, dynamic> toJson() {
    return {'requested_points': requestedPoints, 'note': note};
  }
}
