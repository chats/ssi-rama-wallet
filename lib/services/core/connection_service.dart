import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../models/connection_model.dart';
import 'api_service.dart';

Future<List<Connection>> getConnections() async {
  const api = "connections";

  try {
    Map<String, dynamic> data = await APIService.get(api);
    List<Connection> connections = [];

    data['results'].forEach((e) => connections.add(Connection.fromJson(e)));

    //if (kDebugMode) {
    //  print(connections);
    //}

    return connections;
  } catch (e) {
    throw e.toString();
  }
}

Future<Connection> getConnectionById(String connectionId) async {
  final api = "connections/$connectionId";

  try {
    Map<String, dynamic> data = await APIService.get(api);
    final connection = Connection.fromJson(data);
    return connection;
  } catch (e) {
    throw e.toString();
  }
}

/*
//------- createInvitation() is deprecated, Please us createOOBInviation instead ---- 
Future<Invitation> createInvitation() async {
  const api = "connections/create-invitation";
  Invitation? inv;
  try {
    Map<String, dynamic> data = await APIService.post(api, "{}");
    //print("data = $data");
    inv = Invitation.fromJson(data);
    //if (kDebugMode) {
    //  print("invitation = $inv");
    //}
  } catch (e) {
    //throw e.toString();
    log("Got error: ${e.toString()}");
  }
  return inv!;
}
*/

Future<Invitation> createOOBInvitation() async {
  const api = "out-of-band/create-invitation";
  Invitation? inv;

  const body = {
    "accept": [
      "didcomm/aip1",
      "didcomm/aip2;env=rfc19"
    ],
    "handshake_protocols": [
      "https://didcomm.org/didexchange/1.0",
      "https://didcomm.org/connections/1.0"
    ]
  };

  try {
    Map<String, dynamic> data = await APIService.post(api, body);
    inv = Invitation.fromJson(data);
  } catch (e) {
    log("Got error: ${e.toString()}");
  }
  return inv!;
}

/*
//------- This receiveInvitation() is deprecated, Please use receiveOOBInvitation() instead ------- 
Future receiveInvitation(String invitationUrl) async {
  var api = 'connections/receive-invitation';

  var uri = Uri.parse(invitationUrl);

  var invitation = utf8.decode(base64.decode(uri.queryParameters["c_i"]!));
  //if (kDebugMode) {
  //  print('invitation=$invitation');
  //}

  try {
    await APIService.post(api, invitation);
  } catch (e) {
    throw e.toString();
  }
}
*/

Future receiveOOBInvitation(String invitationUrl) async {
  var api = 'out-of-band/receive-invitation';

  var uri = Uri.parse(invitationUrl);
  var data = base64.normalize(uri.queryParameters["oob"]!);
  var invitation = utf8.decode(base64.decode(data));

  try {
    await APIService.post(api, invitation);
  } catch (e) {
    throw e.toString();
  }
}


Future deleteConnection(String connectionId) async {
  final api = "connections/$connectionId";

  try {
    final response = await APIService.delete(api);
    if (kDebugMode) {
      print(response);
    }
  } catch (e) {
    throw e.toString();
  }
}
