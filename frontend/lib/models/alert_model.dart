class AlertModel {
  final String message;
  final String severity;
  final String metric;
  final double value;
  final String timestamp;
  final String status;

  AlertModel({
    required this.message,
    required this.severity,
    required this.metric,
    required this.value,
    required this.timestamp,
    this.status = "Open",
  });
}