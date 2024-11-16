import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/constants.dart';
import '../../../data/sample_card_data.dart';
import '../../../models/guide_license_model.dart';
import '../../../widgets/exam_cert_card2.dart';
import '../../../widgets/tourist_guide_license_card3.dart';
import '../../credentials/wigets/uknown_card_widget.dart';

class HomeScreen3 extends StatelessWidget {
  const HomeScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: AppBar(
        title: const Row(
          children: [
            Text(
              'Credential',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 8),
            Text('Wallet'),
          ],
        ),
        actions: [
          CircleAvatar(
            //backgroundColor: MyTheme.bgColor.withOpacity(0.5),
            backgroundColor: Colors.black.withOpacity(0.7),
            maxRadius: 22,
            child: SizedBox(
              height: 35,
              width: 35,
              child: Image.asset(
                'assets/images/avatar.png',
                width: 35,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: 200,
                child: ListView.separated(
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 10,
                      );
                    },
                    itemCount: sampleCardData.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      //return MyCard(
                      //  card: myCards[index],
                      //);
                      final credDefId = sampleCardData[index].credDefId;
                      switch (credDefId) {
                        default:
                          return UnknownCard(
                              width: 300,
                              attrs: sampleCardData[index].attrs,
                              press: () {});
                      }
                    }),
              ),
            ],
          )),
    );
  }
}
