import 'dart:convert';
import 'package:http/http.dart' as http;

class MetricsService {

  static Future<Map<String,dynamic>>
  fetchMetrics() async {

    final response = await http.get(
      Uri.parse(
        "http://localhost:8000/metrics"
      ),
    );

    if(response.statusCode==200){

      return jsonDecode(response.body);

    }

    else{

      throw Exception(
          "Failed to load metrics");

    }

  }

}