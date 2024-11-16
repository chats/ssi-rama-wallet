import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../models/verifiable_credential_model.dart';
import 'api_service.dart';
import 'my_shared_preferences.dart';

const credentialsDataKey = "credentials";
const credentialsDataExpire = 0; // 2 minutes

/* ------------------------
 *  Get all credentials
 --------------------------*/
Future<List<VerifiableCredential>> getCredentials() async {
  const api = "credentials";

  final pref = MySharedPreferences();

  try {
    Map<String, dynamic> data = {};

    final strdata = await pref.getDataIfNotExpired(credentialsDataKey);
    if (strdata != null) {
      data = json.decode(strdata);
    } else {
      data = await APIService.get(api);
      await pref.saveData(credentialsDataKey, json.encode(data),
          expireIn: credentialsDataExpire);
    }

    //Initialize connection list;
    List<VerifiableCredential> credentials = [];
    //Import data object to connection list
    data['results'].forEach(
      (cred) => credentials.add(VerifiableCredential.fromJson(cred)),
    );

    if (kDebugMode) {
      print(json.encode(credentials));
    }

    return credentials;
  } catch (e) {
    throw e.toString();
  }
}

/* ------------------------
 *  Get all credentials
 --------------------------*/
Future<VerifiableCredential> getCredentialById(String credentialId) async {
  final api = "credential/$credentialId";

  print("------ Call API: $api");

  try {
    Map<String, dynamic> data = await APIService.get(api);

    //print("------ Data: $data");

    VerifiableCredential credential = VerifiableCredential.fromJson(data);

    if (kDebugMode) {
      print(credential);
    }

    return credential;
  } catch (e) {
    throw e.toString();
  }
}

/* ---------------------------------------------------------
 *  Send credential request to issuer (if received offer)
 -----------------------------------------------------------*/
Future sendCredentialRequest(String credExId) async {
  final api = "issue-credential/records/$credExId/send_request";
  const body = {"auto_remove": true};

  try {
    final result = APIService.post(api, body);
    if (kDebugMode) {
      print(result);
    }
  } catch (e) {
    throw e.toString();
  }
}

/*  --------------------------------------
 *  Remove credential from wallet by id
 ----------------------------------------*/
Future deleteCredential(String credentialId) async {
  final api = "credential/$credentialId";

  final pref = MySharedPreferences();

  print("------ Call API: $api");

  try {
    APIService.delete(api);
    pref.removeData(credentialsDataKey);
  } catch (e) {
    throw e.toString();
  }
}

Future getCredentialIdByCredExIdV2(String credExId) async {
  final api = "issue-credential-2.0/records/$credExId";

  try {
    final data = await APIService.get(api);

    //if (kDebugMode) {
    //  print(data);
    //}

    return data["indy"]['cred_id_stored'];
  } catch (e) {
    throw e.toString();
  }
}
