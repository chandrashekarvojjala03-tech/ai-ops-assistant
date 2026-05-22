import '../models/alert_model.dart';
import 'package:intl/intl.dart';

class AlertService {
  static List<AlertModel> alerts = [];
  static Set<String> existingAlerts = {};

  static void checkMetrics({
    required double cpu,
    required double ram,
    required double disk,
  }) {

    createAlert(
      metric: "CPU",
      value: cpu,
      threshold: 80,
      severity: "CRITICAL",
    );

    createAlert(
      metric: "RAM",
      value: ram,
      threshold: 80,
      severity: "CRITICAL",
    );

    createAlert(
      metric: "Disk",
      value: disk,
      threshold: 85,
      severity: "WARNING",
    );
  }

  static void createAlert({
    required String metric,
    required double value,
    required int threshold,
    required String severity,
  }) {

    if(value<threshold){

      existingAlerts.remove(metric);

      return;
    }

    if(existingAlerts.contains(metric)) return;

    existingAlerts.add(metric);

    alerts.insert(
      0,
      AlertModel(
        message: "$metric usage high: ${value.toInt()}%",
        severity: severity,
        metric: metric,
        value: value,
        timestamp:
        "${DateTime.now().hour.toString().padLeft(2,'0')}:${DateTime.now().minute.toString().padLeft(2,'0')}",
      ),
    );
  }
}