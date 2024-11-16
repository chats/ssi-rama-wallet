import 'package:flutter/material.dart';

import '../../../../data/sample_card_data.dart';
import '../../../../widgets/tourist_guide_license_card3.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          TouristGuideLicenseCard3(credential: sampleCardData[0], press: () {}),
    );
  }
}
