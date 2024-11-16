import 'dart:convert';

import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../services/acapy/acapy_websocket_service.dart';

class WebSocketMessage {
  final String title;
  final String content;
  final MessageType type;

  WebSocketMessage(this.title, this.content, this.type);
}

// Enum for message types
enum MessageType {
  invitation,
  issue,
  verify,
  other
}



class WebSocketDemo extends StatefulWidget {
  const WebSocketDemo({super.key});

  @override
  _WebSocketDemoState createState() => _WebSocketDemoState();
}

class _WebSocketDemoState extends State<WebSocketDemo> {
  late AcapyWebSocket acapyWs;
  List<WebSocketMessage> messages = [];

  @override
  void initState() {
    super.initState();
    
    acapyWs = AcapyWebSocket(
      wsUrl: agentWss,  // Replace with your ACA-Py websocket URL
      onMessageCallback: (message) {
        setState(() {
          // Handle different message types
          //print('Received message: ${json.encode(message)}');
          /*
          if (message['@type'] != null) {
            String messageType = message['@type'];
            
            switch (messageType) {
              case 'did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/connections/1.0/invitation':
                handleConnectionInvitation(message);
                break;
              case 'did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/connections/1.0/request':
                handleConnectionRequest(message);
                break;
              case 'did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/connections/1.0/response':
                handleConnectionResponse(message);
                break;
              default:
                messages.add('Received message: ${json.encode(message)}');
            }
          }*/
          if (message['topic'] != null) {
            String topic = message['topic'];
            
            switch (topic) {
              case 'connections':
              case 'connection_reuse':
              case 'out_of_band':
                handleConnectionInvitation(message);
                break;
              case 'issue_credential':
              case 'issue_credential_v2_0':
                handleIssueCredential(message);
                break;
              case 'present_proof':
              case 'present_proof_v2_0':
                handlePresentProof(message);
                break;
              default:
//                messages.add('Received message: ${json.encode(message)}');
            }
          }
        });
      },
    );
    
    acapyWs.connect();
  }

  void handleConnectionInvitation(dynamic message) {
    final payload = message['payload'];
    switch (payload['state']) {
      case 'invitation':
        messages.add(
          WebSocketMessage(
            'Receive Invitation',
            'ID: ${payload['connection_id']}',
            MessageType.invitation,
          )
        );
        break;
      case 'request':
        messages.add(
          WebSocketMessage(
            'Connection Request',
            'From: ${payload['their_label']}\nID: ${payload['connection_id']}',
            MessageType.invitation,
          )
        );
        break;
//      case 'response':
//        messages.add(
//          WebSocketMessage(
//            'Received connection response: ${payload['connection_id']}',
//            MessageType.invitation,
//          )
//        );
//        break;
      case 'active':
        messages.add(
          WebSocketMessage(
            'Connection Active',
            'ID: ${payload['connection_id']}',
            MessageType.invitation,
          )
        );
        break;
      default:
    }
  }

  void handleIssueCredential(dynamic message) {
    final payload = message['payload'];
    switch (payload['state']) {
      case 'offer_received':
      case 'offer-received':
        messages.add(
          WebSocketMessage(
            'Received credential offer.',
            'ID: ${payload['cred_ex_id']}',
            MessageType.issue,
          )
        );
        break;
      case 'request_sent':
      case 'request-sent':
        messages.add(
          WebSocketMessage(
            'Sent credential request.',
            'ID: ${payload['cred_ex_id']}',
            MessageType.issue,
          )
        );
        break;
      case 'request_received':
      case 'request-received':
        messages.add(
          WebSocketMessage(
            'Received credential request.',
            'ID: ${payload['cred_ex_id']}',
            MessageType.issue,
          )
        );
        break;
      case 'credential_received':
      case 'credential-received':
        messages.add(
          WebSocketMessage(
            'Received Credential.',
            'Exchane ID: ${payload['cred_ex_id']}',
            MessageType.issue,
          )
        );
        break;
      default:
    }
  }

  void handlePresentProof(dynamic message) {
    final payload = message['payload'];
    //print('state: ${payload['state']}');

    switch (payload['state']) {
      case 'request_received':
      case 'request-received':
        messages.add(  
          WebSocketMessage(
            'Recived proof request',
            'Exchange ID: ${payload['pres_ex_id']}',
            MessageType.verify,
          )
        );
        break;
      case 'request_sent':
      case 'request-sent':
        messages.add(  
          WebSocketMessage(
            'Sent proof request',
            'Exchange ID: ${payload['pres_ex_id']}',
            MessageType.verify,
          )
        );
        break;
      case 'presentation_received':
      case 'presentation-received':
        messages.add(
          WebSocketMessage(
            'Received proof presentation',
            'Exchange ID: ${payload['pres_ex_id']}',
            MessageType.verify,
          )
        );
        break;
      case 'presentation_sent':
      case 'presentation-sent':
        messages.add(
          WebSocketMessage(
            'Sent proof presentation',
            'Exchange ID: ${payload['pres_ex_id']}',
            MessageType.verify,
          )
        );
        break;
      default:
    }
  }

  void handleOtherMessage(dynamic message) {
    messages.add(
      WebSocketMessage(
        'Received message',
        json.encode(message),
        MessageType.other
      )
    );
  }
  
  Color getMessageColor(MessageType type) {
    switch (type) {
      case MessageType.invitation:
        return Color(0xFFE0F7E0).withAlpha(224); // Light green
      case MessageType.issue:
        return Color(0xFFE0F0FF).withAlpha(224); // Light blue
      case MessageType.verify:
        return Color(0xFFF0E0FF).withAlpha(224); // Light purple
      case MessageType.other:
        return Color(0xFFF5F5F5).withAlpha(224); // Light gray
    }
  }

  @override
  void dispose() {
    acapyWs.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('message length: ${messages.length}');
    return Scaffold(
      appBar: AppBar(
        title: Text('ACA-Py WebSocket Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: getMessageColor(message.type),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  title: Text(
                    message.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}