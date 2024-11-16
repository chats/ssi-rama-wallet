// credentials_service.dart
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Credential {
  final String id;
  final String issuer;
  final DateTime issuanceDate;
  final Map<String, dynamic> attributes;
  final String? credentialType;

  Credential({
    required this.id,
    required this.issuer,
    required this.issuanceDate,
    required this.attributes,
    this.credentialType,
  });

  factory Credential.fromJson(Map<String, dynamic> json) {
    //final credData = json['credential'] ?? {};
    final credData = json['cred_value'] ?? {};
    final credSubject = credData['credentialSubject'] ?? {};
    
    return Credential(
      id: json['record_id'] ?? '',
      issuer: credData['issuer'] ?? '',
      issuanceDate: DateTime.tryParse(credData['issuanceDate'] ?? '') ?? DateTime.now(),
      attributes: Map<String, dynamic>.from(credSubject),
      credentialType: (credData['type'] as List?)?.lastOrNull?.toString(),
    );
  }
}

class AcaPyCredentialService {
  final String baseUrl;
  final String apiKey;

  AcaPyCredentialService({
    required this.baseUrl,
    required this.apiKey,
  });

  Map<String, String> get headers => {
    'X-API-KEY': apiKey,
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<List<Credential>> getW3cCredentials() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/credentials/w3c'),
        headers: headers,
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = List<Map<String, dynamic>>.from(data['results'] ?? []);
        return results.map((json) => Credential.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch W3C credentials: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error fetching W3C credentials: $e');
    }
  }

  Future<void> deleteW3cCredential(String credentialId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/credential/w3c/$credentialId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete credential: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error deleting credential: $e');
    }
  }
}