import 'package:http/http.dart' as http;
import 'dart:convert';

class AcaPyConnectionService {
  final String baseUrl;
  final String apiKey;

  AcaPyConnectionService({
    required this.baseUrl,
    required this.apiKey,
  });

  Map<String, String> get headers => {
    'X-API-KEY': apiKey,
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> createOobInvitation({
    String? alias,
    String? goalCode,
    String? goal,
    bool handshakeProtocols = true,
    bool usePublicDid = false,
    bool multiUse = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/out-of-band/create-invitation'),
        headers: headers,
        body: jsonEncode({
          'alias': alias,
          'handshake_protocols': handshakeProtocols ? ['https://didcomm.org/connections/1.0'] : [],
          'use_public_did': usePublicDid,
          'multi_use': multiUse,
          if (goalCode != null) 'goal_code': goalCode,
          if (goal != null) 'goal': goal,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create OOB invitation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error creating OOB invitation: $e');
    }
  }

  Future<Map<String, dynamic>> receiveOobInvitation({
    required String invitationUrl,
    String? alias,
    bool autoAccept = true,
    bool useExistingConnection = true,
  }) async {
    try {
      // First, decode the invitation URL and extract the invitation
      final invitation = await decodeOobInvitation(invitationUrl);
      
      // Then, receive the invitation
      final response = await http.post(
        Uri.parse('$baseUrl/out-of-band/receive-invitation'),
        headers: headers,
        body: jsonEncode({
          'invitation': invitation,
          'alias': alias,
          'auto_accept': autoAccept,
          'use_existing_connection': useExistingConnection,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to receive OOB invitation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error receiving OOB invitation: $e');
    }
  }

  Future<Map<String, dynamic>> decodeOobInvitation(String invitationUrl) async {
    // Remove 'c_i=' or 'oi=' prefix if present and decode base64
    String cleanUrl = invitationUrl;
    if (invitationUrl.contains('?c_i=')) {
      cleanUrl = invitationUrl.split('?c_i=')[1];
    } else if (invitationUrl.contains('?oob=')) {
      cleanUrl = invitationUrl.split('?oob=')[1];
    }
    
    // Handle URL-safe base64 encoding
    cleanUrl = cleanUrl.replaceAll('-', '+').replaceAll('_', '/');
    while (cleanUrl.length % 4 != 0) {
      cleanUrl += '=';
    }

    try {
      final decoded = utf8.decode(base64Url.decode(cleanUrl));
      return jsonDecode(decoded);
    } catch (e) {
      throw Exception('Failed to decode invitation URL: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getConnections() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/connections'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('Failed to fetch connections');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}