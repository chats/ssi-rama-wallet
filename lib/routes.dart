//import 'package:dot_ssi_wallet/screens/credentials/credential_screen.dart';
//import 'package:dot_ssi_wallet/screens/__archives/home/xxxxx/home_screenOLD.dart';
//import 'package:dot_ssi_wallet/screens/sockets/socket_event_screen.dart';
//import 'package:dot_ssi_wallet/screens/scan_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:ssi_rama_wallet/screens/sockets/socket_demo_screen.dart';

//import 'screens/credential_details_screen.dart';
import 'features/settings/screens/settings_profile.dart';
import 'features/settings/screens/settings_screen.dart';
import 'screens/credentials/credential_screen.dart';
import 'screens/credentials/credential_v2_screen.dart';
import 'screens/scan_qr_screen.dart';
import 'screens/sockets/socket_event_screen.dart';

final appRoutes = <String, WidgetBuilder>{
  //'/': (BuildContext context) => const HomeScreen(),
  '/credentials': (BuildContext context) => const CredentialsV2Screen(),
  //'/credential-details': (BuildContext context) => const CredentialDetailsScreen(),
  '/scan': (BuildContext context) => const ScanQRScreen(),
//  '/messages': (BuildContext context) => const SocketEventScreen(),
  '/messages': (BuildContext context) => const WebSocketDemo(),
  '/settings/profile': (BuildContext context) => const SettingsProfile(),
  '/settings': (BuildContext context) => const SettingsScreen(),
};
