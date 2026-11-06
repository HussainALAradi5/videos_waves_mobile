enum AdminRequestStatus {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected'),
  cancelled('cancelled');

  const AdminRequestStatus(this.wireValue);

  final String wireValue;

  static AdminRequestStatus fromWire(String value) => AdminRequestStatus.values
      .firstWhere((status) => status.wireValue == value, orElse: () => AdminRequestStatus.pending);
}
