//import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'home_controller.dart';
import '../../data/announcement_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rama5G ID Wallet"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24.0),
              child: Center(
                child: Image.asset('assets/images/vertex/vertex-brand.png'),
              ),
            ),*/
            //searchBar(context),
            //annoucement(context),
            //SizedBox(height: 20),
            //prefersCards(context),
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          ],
        ),
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    final homeController = Get.put(HomeController());
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                if (value.isNotEmpty) {
                  homeController.setSearchActive(true);
                } else {
                  homeController.setSearchActive(false);
                }
                print('searchActive: ${homeController.searchActive}');
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.surfaceVariant,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //isDense: true,
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        GetX<HomeController>(
          builder: (controller) {
            return Visibility(
              visible: controller.searchActive,
              child: TextButton(
                onPressed: () {
                  controller.setSearchActive(false);
                  print('searchActive: ${controller.searchActive}');
                },
                child: Text("Cancel"),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget annoucement(BuildContext context) {
    const fgColor = Colors.white;
    List<Color> colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.purple.shade400,
    ];
    final textTheme = Theme.of(context).textTheme;
    int idx = 0;
    /*
    return CarouselSlider(
      options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 10)),
      //items: [1, 2, 3, 4, 5].map((i) {
      items: announcements.map((i) {
        return Builder(
          builder: (BuildContext context) {
            final color = colors[idx % colors.length];
            idx++;
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: color,
                  //image: DecorationImage(
                  //  image: NetworkImage(i.imageUrl!),
                  //  fit: BoxFit.cover,
                  //),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${i.title}',
                        style: TextStyle(
                            fontSize: textTheme.titleMedium!.fontSize,
                            color: fgColor),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${i.description}',
                        style: TextStyle(
                            fontSize: textTheme.bodySmall!.fontSize,
                            color: fgColor),
                      ),
                    ],
                  ),
                ));
          },
        );
      }).toList(),
    );
    */
    return Container();
  }

  Widget prefersCards(BuildContext context) {
    return Column(
      children: announcements.map((i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            child: ListTile(
              title: Text(i.title),
              subtitle: Text(i.description),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget dialogShow(BuildContext context, {required String key, required String value}) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            Image.asset(
              'assets/images/concert.png',
              height: 100,
              width: 100,
            ),
            SizedBox(height: 10),
            Text(
              'Bangkok Nights:\nA Symphony Under the Stars',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            TicketDetailItem(
              icon: Icons.calendar_today,
              text: '2 ธ.ค. 2566 - 7 ก.ย. 2567, 14.15',
            ),
            TicketDetailItem(
              icon: Icons.location_on,
              text: 'เมืองทองธานี',
            ),
            TicketDetailItem(
              icon: Icons.confirmation_number,
              text: 'No. 510000531099',
            ),
            TicketDetailItem(
              icon: Icons.airline_seat_recline_normal,
              text: 'B2, BB49',
            ),
            SizedBox(height: 10),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'จำนวนทั้งหมด',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '1 ใบ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TicketDetailItem extends StatelessWidget {
  final IconData icon;
  final String text;

  TicketDetailItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
