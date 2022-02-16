import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:seed_sales/constants.dart';
import 'package:seed_sales/push_notification_service.dart';
import 'package:seed_sales/router.dart';
import 'package:seed_sales/screens/Desingation/provider/desingation_provider.dart';
import 'package:seed_sales/screens/categories/provider/category_provider.dart';
import 'package:seed_sales/screens/customers/provider/customer_provider.dart';
import 'package:seed_sales/screens/dashbord/body.dart';
import 'package:seed_sales/screens/dashbord/provider/assigned_business_provider.dart';
import 'package:seed_sales/screens/dashbord/provider/dashboard_provider.dart';
import 'package:seed_sales/screens/enquiry/provider/appointment_provider.dart';
import 'package:seed_sales/screens/login/body.dart';
import 'package:seed_sales/screens/login/provider/login_provider.dart';
import 'package:seed_sales/screens/products/provider/products_provider.dart';
import 'package:seed_sales/screens/pus_notification.dart';
import 'package:seed_sales/screens/roles/provider/role_provider.dart';
import 'package:seed_sales/screens/subcategory/provider/sub_category_provider.dart';
import 'package:seed_sales/screens/tax/provider/tax_provider.dart';
import 'package:seed_sales/screens/user/provider/users_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'notification.dart';
import 'screens/bussiness/provider/business_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  //call awesomenotification to how the push notification.
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Periodic task registration

  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  messaging.setForegroundNotificationPresentationOptions(alert: true);
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print(
      'User granted permission: ${settings.authorizationStatus}'); // initialize firebase before actual app get start.
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white)
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

Future _showNotificationWithDefaultSound(flip) async {
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your NOTIFICATION_CHANNEL id', 'NOTIFICATION_CHANNEL',
      importance: Importance.max, priority: Priority.high);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flip.show(
      0,
      'GeeksforGeeks',
      'Your are one step away to connect with GeeksforGeeks',
      platformChannelSpecifics,
      payload: 'Default_Sound');
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  Future<bool> initShared() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    token = _prefs.getString('token')!;
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashBoardProvider()),
        ChangeNotifierProvider(create: (_) => DesignationProvider()),
        ChangeNotifierProvider(create: (_) => RoleProviderNew()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => BusinessProvider()),
        ChangeNotifierProvider(create: (_) => UserProviderNew()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => SubCategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => TaxProvider()),
        ChangeNotifierProvider(create: (_) => AssignedBussinessProvider())
      ],
      child: MaterialApp(
        color: blackColor,
        title: 'Body Perfect',
        theme: ThemeData(
            textTheme: GoogleFonts.bellezaTextTheme(
              Theme.of(context).textTheme,
            ),
            primaryColor: blackColor,
            scaffoldBackgroundColor: lightBlack),
        onGenerateRoute: RouterPage.generateRoute,
        home: const SplashFuturePage(),
      ),
    );
  }
}

class SplashFuturePage extends StatefulWidget {
  const SplashFuturePage({Key? key}) : super(key: key);

  @override
  _SplashFuturePageState createState() => _SplashFuturePageState();
}

class _SplashFuturePageState extends State<SplashFuturePage> {
  String? token;
  Future<bool> initShared() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    token = _prefs.getString('token');
    return true;
  }

  Future<Widget> futureCall() async {
    await initShared();
    await Future.delayed(const Duration(milliseconds: 3000));
    return token != null
        ? Future.value(const DashBoard())
        : Future.value(const Login());
  }

  Future<void> updateToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      Provider.of<UserProviderNew>(context, listen: false).updateToken(token);
    }
  }

  @override
  void initState() {
    updateToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/icons/logo.png'),
      title: const Text(
        appName,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      showLoader: true,
      loadingText: const Text("Loading..."),
      futureNavigator: futureCall(),
    );
  }
}

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

Future<dynamic> myForgroundMessageHandler(RemoteMessage message) async {
  return Future<void>.value();
}
