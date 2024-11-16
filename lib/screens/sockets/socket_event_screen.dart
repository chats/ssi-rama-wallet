import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../constants/constants.dart';
import '../../features/history/transactions/data/transaction_data.dart';
import '../../features/history/transactions/data/transaction_service.dart';
import '../../models/verifiable_credential_model.dart';
import '../../services/core/credential_service.dart';
import '../../widgets/exam_cert_card.dart';
import '../../widgets/exam_seat_card.dart';
import '../credentials/wigets/medical_certificate_card.dart';
import '../credentials/wigets/tourist_guide_license_card2.dart';

class SocketEventScreen extends StatefulWidget {
  const SocketEventScreen({super.key, this.scanNow = false});
  final bool? scanNow;

  @override
  State<SocketEventScreen> createState() => _SocketEventScreenState();
}

class _SocketEventScreenState extends State<SocketEventScreen> {
  //List<Widget> items = [];
  List<dynamic> items = [];
  int itemCount = 0;
  //List<String> messages = [];

  //final _channel = WebSocketChannel.connect(
  //  Uri.parse(Constants.agentWss),
  //);

  int proposeCredentialCount = 0;
  int proposeProofCount = 0;

  _addItem() {
    setState(() {
      itemCount = itemCount + 1;
    });
  }

  List<String> textMessages = ["Sunday", "Monday", "Tuesday"];
  final channel =
      WebSocketChannel.connect(Uri.parse('$agentWss?apikey=$agentKey'));

  @override
  void initState() {
    super.initState();
    channel.stream.listen((event) {
      if (mounted) {
        setState(() {
          final o = json.decode(event);
          final topic = o["topic"];
          //if (topic != 'ping') {
          //  print(
          //      "====== Topic = $topic, state = ${o["payload"]["state"]} ======");
          // }
          final state = (o["payload"] != null) ? o["payload"]["state"] : "";

          if (topic == "connections" && state == "active") {
            items.add(event);
          } else if ((topic == "issue_credential" ||
                      topic == "issue_credential_v2_0") &&
                  (state == "offer_received" ||
                      state == "offer-received" ||
                      state == "credential_acked") ||
              state == "credential-received" ||
              state == "done") {
            //print("========== Issue credential = $event");
            items.add(event);
          } else if ((topic == "present_proof" ||
                  topic == "present_proof_v2_0") &&
              (state == "presentation_sent" ||
                  state == "presentation-sent" ||
                  state == "verified" ||
                  state == "presentation_acked")) {
            print("========== Present proof = $event");
            items.add(event);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //Get.offAll(() => CredentialScreen());
            //int count = 0; // Pop 2 Step;
            //Navigator.of(context).popUntil((_) => count++ >= 2);
            //Get.until((route) => count++ >= 2);
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            //return items[index];
            /*
            final msg = json.decode(items[index]);
            final topic = msg["topic"];
            print("============ Topic = $topic");
            final payload = msg["payload"];
            if (topic == "connections") {
              print(
                  "--------------------- Connection --------------------------");
              return _buildConnectionTopic(payload);
              //} else if (topic == "issue_credential") {
              // return _buildIssueCredentialTopic(payload);
              //} else if (topic == "present_proof") {
              //  return _buildPresentProofTopic(payload);
            }
            */
            //print("========== $items[index]");
            //var msg = json.decode(items[index]);
            //setState(() {
            //msg = json.decode(items[index]);
            //  itemCount++;
            //});

            //print("============ topic = ${msg["topic"]}");
            //print("============ itemCount = $itemCount");
            //return null;
            //return ListTile(title: Text(items[index]));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildXTile(context, items[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildXTile(BuildContext context, dynamic item) {
    final o = json.decode(item);
    final topic = o["topic"];
    final payload = o["payload"];
    //final state = o["payload"]["state"];
    //final payload =  o["payload"]
    print("Topic = $topic");
    //print("State = $payload['state']");
    if (topic == "connections" || topic == "out_of_band") {
      return _buildConnectionTopic(context, payload);
    } else if (topic == "issue_credential" ||
        topic == "issue_credential_v2_0") {
      return _buildIssueCredentialTopic(payload);
    } else if (topic == "present_proof" || topic == "present_proof_v2_0") {
      print("--------Present Proof ------");
      print("--------payload = $payload ------");
      return _buildPresentProofTopic(payload);
    }
    return SizedBox.shrink();
  }

  Widget _buildTile(Widget title, Widget subtitle, {Color? color}) {
    return Container(
      //height: 80,
      decoration: BoxDecoration(
          color: (color != null) ? color : Colors.green.shade50,
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(title: title, subtitle: subtitle),
      ),
    );
  }

  Widget _buildConnectionTopic(BuildContext context, dynamic payload) {
    final theme = Theme.of(context);
    final state = payload["state"];
    return Container(
        decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20)),
        child: Builder(
          builder: (context) {
            if (state == "active") {
              /**
               * This is special case for E-Exam
               */
              //print("Their label: ${payload["their_label"]}");
              /*
              if (payload["their_label"].toString().trim() == "DOT E-Exam" &&
                  proposeCredentialCount == 0) {
                //print("---------- To send credential proposal ----------");
                proposeRCredentialCount++;
                return eExamConnected(context, payload);
              }
              */
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("You're connected to: "),
                    Text(
                      payload["their_label"]!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        //color: Colors.black87,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Text(
                payload["state"]!,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              );
              //return const SizedBox.shrink();
            }
          },
        ));
  }

  Widget _buildIssueCredentialTopic(dynamic payload) {
    Color color = Colors.blue.shade50;
    final state = payload["state"];
    final credExId = payload["credential_exchange_id"];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Builder(builder: (context) {
        //print("Issue -- State = $state");
        if (state == "offer_received" || state == "offer-received") {
          //sendCredentialRequest(credExId);
          //print("payload = ${payload.toString()}");
          return _buildTile(
            const Text("Accepted credential offer"),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Offering is accept automatically.")],
            ),
            color: color,
          );
        } else if (state == "credential_acked" ||
            state == "credential_received" ||
            state == "credential-received") {
          //print("payload = ${payload.toString()}");
          //final creddefId = payload["credential_definition_id"];
          //Future<VerifiableCredential> credential = getCredentialById(payload["credential_id"]);
          Transaction tx = Transaction(
            title: "Credential received/acked",
            //description: "ID: ${payload["credential_id"]}",
            description: "CredExID: ${payload["cred_ex_id"]}",
            createdAt: DateTime.now(),
            id: null,
          );
          print("------ PAYLOAD ------" + payload.toString());
          TransactionService.addTransaction(tx);
          String credential_id = payload["credential_id"] ?? "";
          return _buildTile(
            const Text("Credential received and stored"),
            Column(
              children: [
                //const Text("Credential acknownledged and stored."),
                SizedBox(height: 8),
                (credential_id.isEmpty)
                    ? Container()
                    : _credentialCard(credential_id),
              ],
            ),
            color: color,
          );
        }
        return credExId == null
            ? Container()
            : _buildTile(
                const Text("Issue credential"), Text("cred_ex_id: $credExId"),
                color: color);
      }),
    );
  }

  Widget _buildPresentProofTopic(dynamic payload) {
    Color color = Colors.purple.shade50;
    final state = payload["state"];
    final verified = payload["verified"];
    final presExId = payload["presentation_exchange_id"];
    print('_buildPresentProofTopic');
    print(payload);
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Builder(builder: (context) {
        if (state == "presentation_sent") {
          return _buildTile(
            const Text(
              "Send Presentation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text("From ${payload["their_label"]}"),
                Text("Presentation sent to verifier."),
              ],
            ),
            color: color,
          );
        } else if (state == "presentation_acked") {
          /*Transaction tx = Transaction(
            title: "Presentation sent ${payload["their_label"]}",
            description: "ID: $presExId",
            createdAt: DateTime.now(),
            id: 0,
          );
          TransactionService.addTransaction(tx);*/
          return _buildTile(
            const Text(
              "Presentation Acknowledged.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text("From ${payload["their_label"]}"),
                Text("Verifier received presentation."),
              ],
            ),
            color: color,
          );
        } else if (state == "verified") {
          /*Transaction tx = Transaction(
            title: "Verified by ${payload["their_label"]}",
            description: "Presentation exchange ID: $presExId",
            createdAt: DateTime.now(),
            id: 0,
          );
          TransactionService.addTransaction(tx);*/
          return _buildTile(
              const Text("Present proof"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Symbols.verified,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text("Your credential is verified by"),
                    ],
                  ),
                  Text(payload["their_label"],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
              color: color);
        }
        return _buildTile(const Text("Present proof"), const Text(""));
      }),
    );
  }

  Widget _credentialCard(String credentialId) {
    dispose();
    return FutureBuilder(
        future: getCredentialById(credentialId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final credential = snapshot.data as VerifiableCredential;
            switch (credential.credDefId) {
//              case examSeatCredDefs:
//                return ExamSeatCard(credential: credential, press: () {});
//              case examCertCredDefs:
//                return ExamCertCard(credential: credential, press: () {});
//              case examTestCredDefs:
//                return UnknownCard(attrs: credential.attrs, press: () {});
              case medicalCertificateCredDefs:
                return MedicalCertificateCard(
                    attrs: credential.attrs, press: () {});
              case guideLicenseCredDefs:
                return TouristGuideLicenseCard2(
                    press: () {}, credential: credential);
              default:
                return const SizedBox.shrink();
            }
          }
        });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
