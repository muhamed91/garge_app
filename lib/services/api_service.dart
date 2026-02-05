import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://taskgaragebackend-beewaebjexf7e8ht.switzerlandnorth-01.azurewebsites.net';

  Future<List<dynamic>> getWorkOrderItems() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Workorders'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Map<String, dynamic>> getWorkOrder(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Workorders/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    debugPrint(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('WorkOrder konnte nicht geladen werden');
    }
  }

  Future<Map<String, dynamic>> createWorkOrder(
    Map<String, dynamic> workOrderData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Workorders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(workOrderData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create work order: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateWorkOrder(
    int id,
    Map<String, dynamic> workOrderData,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Workorders/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(workOrderData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Auftrag nicht gefunden');
    } else {
      throw Exception(
        'Fehler beim Aktualisieren (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<void> deleteWorkOrder(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/Workorders/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      // erfolgreich gelöscht
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Auftrag nicht gefunden');
    } else {
      throw Exception(
        'Fehler beim Löschen (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<Map<String, dynamic>> updateWorkOrderStatus(int id, int status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/Workorders/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"status": status}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Status konnte nicht aktualisiert werden: "
        "${response.statusCode} ${response.body}",
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
