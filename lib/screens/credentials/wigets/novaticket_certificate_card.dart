import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../../models/exam_seat_model.dart';
import '../../../models/exam_test_model.dart';
import '../../../models/novaticket_certificate_model.dart';
import '../../../models/verifiable_credential_model.dart';

class NovaTicketCertificateCard extends StatelessWidget {
  const NovaTicketCertificateCard({
    super.key,
    required this.press,
    this.width = 350,
    required this.attrs,
  });
  final double? width;
  //final VerifiableCredential credential;
  final Map<String, dynamic> attrs;
  final VoidCallback press;

  static const double cardSizeRatio = 1.58577250834;
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('th_TH', null);
    //double cardHeight = 154.0;
    //double cardWidth = cardHeight * cardSizeRatio;

    //if (width! > 0.00) {
    //  cardWidth = width!;
    //  cardHeight = width! / cardSizeRatio;
    //}

    //final Map<String, dynamic> attrs = credential.attrs;
    //final ExamTest examTest = ExamTest.fromJson(credential.attrs);

    return GestureDetector(
      onTap: press,
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          //side: const BorderSide(color: Colors.red, width: 1),
        ),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          //return Container(width: c,);
          final cardWidth = width! > 0.00 ? width! : constraints.maxWidth;
          final cardHeight = cardWidth / cardSizeRatio;

          return _buildCard(context, cardWidth, cardHeight, attrs);
        }),
      ),
    );
  }

  Widget _buildCard(BuildContext context, double cardWidth, double cardHeight,
      dynamic attrs) {
    NovaTicket cert = NovaTicket.fromJson(attrs);
    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/icons/logo.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.04),
            BlendMode.dstATop,
          ),
          //colorFilter: ColorFilter.mode(
          //  Colors.white.withOpacity(0.8),
          //  BlendMode.dstATop,
          //),
        ),
        //color: Colors.white70,
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultBorderRadius),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          //colors: [Color(0xFFFAFAFA), Color(0xFFF0F0F0)],

          colors: [
            Color.fromARGB(255, 237, 108, 170),
            Color.fromARGB(255, 193, 110, 226),
            Color.fromARGB(255, 173, 111, 249),
            Color.fromARGB(255, 116, 100, 209)
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              //color: MyTheme.bgColor,
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(defaultBorderRadius),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 27,
                  //color: Colors.grey,
                  //offset: Offset(0, 3),
                  //blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    //child:
                    //    _buildUnkownProperty(context, credential.attrs))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("NovaTicket VC",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                )),
                        //Text("Unknown Credential",
                        //    style: Theme.of(context).textTheme.titleMedium),
                        Container(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  cert.eventName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${cert.eventId}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                    Text(
                                      "${cert.eventDateTime}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                    Text("${cert.eventRound}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.white)),
                                         Text("${cert.seatNumber}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white)),
                                    // Image.network(
                                    //   "${cert.eventImage}",
                                    //   height:
                                    //       20, 
                                    //   width: double
                                    //       .infinity, 
                                    //   fit:
                                    //       BoxFit.cover, 
                                    // ),
                                  ],
                                ),
                              ),
//                              ListTile(
//                                title: Text("Text"),
//                                subtitle: Text("Text"),
//                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )

                //child: Container()))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNovaticketCerificateProperty(
      BuildContext context, Map<String, dynamic> attrs) {
    return attrs.length == 0
        ? Container()
        : SliverToBoxAdapter(
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    title: Text("Issued Date"),
                    subtitle: Text(
                      DateFormat.yMMMMd('th_TH').format(
                        DateTime.parse(attrs['issuedDate']),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("Issued By"),
                    subtitle: Text(attrs['issuedBy']),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildUnkownProperty(
      BuildContext context, Map<String, dynamic> attrs) {
    return attrs.length == 0
        ? Container()
        : SliverToBoxAdapter(
            child: ListView.builder(
                itemCount: attrs.length > 3 ? 3 : attrs.length,
                itemBuilder: (context, index) {
                  final key = attrs.keys.elementAt(index);
                  final value = attrs[key];
                  print("key: $key, value: $value");
                  return Container();
                  //return ListTile(
                  //  title: Text("key"),
                  //  subtitle: Text("value"),
                  //);
                  //return ListTile(
                  //  title: Text(key),
                  //  subtitle: Text(value!.toString()),
                  //);
                }),
          );
  }
}
