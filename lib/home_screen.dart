import 'dart:async';

import 'package:almuthaber_app/about_app_screen.dart';
import 'package:almuthaber_app/account_screen.dart';
import 'package:almuthaber_app/api/notifications_services.dart';
import 'package:almuthaber_app/constants/colors_app.dart';
import 'package:almuthaber_app/data/models/offers_data.dart';
import 'package:almuthaber_app/data/models/usersInformations.dart';
import 'package:almuthaber_app/job_details_screen.dart';
import 'package:almuthaber_app/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' as Flutter;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  String? id;

  HomeScreen({this.id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationsServices notificationsServices = NotificationsServices();

  void openWhatsApp() async {
    String whatsappUrl = "https://wa.me/+249913279549";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  late TextEditingController searchController;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    notificationsServices.requestNotificationPermission();

    notificationsServices.firebaseInit(context);

    notificationsServices.setupInteractMessage(context);

    notificationsServices.isTokenRefresh();

    notificationsServices.getDeviceToken().then((value) {
      print('device token');
      print(value);
    });

    _subscribeToTopic();
    initConnectivity();
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      setState(() {
        _connectionStatus =
            results.isNotEmpty ? results.first : ConnectivityResult.none;
      });
      print('Connection State Changed: $_connectionStatus');
    });
  }

  // Subscribe to the topic "all_users"
  void _subscribeToTopic() {
    _firebaseMessaging.subscribeToTopic('all_users');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  late ConnectivityResult _connectionStatus;

  Future<void> initConnectivity() async {
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    ConnectivityResult result =
        results.isNotEmpty ? results.first : ConnectivityResult.none;
    setState(() {
      _connectionStatus = result;
    });
    print('Initial Connection State: $_connectionStatus');
  }

  @override
  Widget build(BuildContext context) {
    Widget buildOfferCard(OffersData offer) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    offer.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textDirection: Flutter.TextDirection.rtl,
                    style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo'),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    offer.description,
                    textAlign: TextAlign.right,
                    textDirection: Flutter.TextDirection.rtl,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Cairo'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat.yMMMMd('ar')
                            .format(DateTime.parse(offer.publishingDate)),
                        textAlign: TextAlign.right,
                        textDirection: Flutter.TextDirection.rtl,
                        style: const TextStyle(
                            fontSize: 8.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w200,
                            fontFamily: 'Cairo'),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        offer.city,
                        style: const TextStyle(
                            fontSize: 8.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w200,
                            fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: -4,
                left: 16,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kMainTitleColor,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JobDetailsScreen(
                                    id: offer.id,
                                    title: offer.title,
                                  )));
                    },
                    child: const Text(
                      'قدم على الوظيفة',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: Colors.white),
                    )))
          ],
        ),
      );
    }

    return _connectionStatus.toString() == 'ConnectivityResult.none'
        ? Flutter.Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'خطأ 404',
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w800,
                        color: Colors.black87),
                  ),
                  Text(
                    'التطبيق غير متصل بالإنترنت',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              iconTheme: const IconThemeData(color: Colors.black87),
              title: Container(
                height: 48,
                width: 48,
                decoration: Flutter.BoxDecoration(
                    borderRadius: Flutter.BorderRadius.circular(
                      6,
                    ),
                    image: const Flutter.DecorationImage(
                        image: Flutter.AssetImage('images/logo.jpg'),
                        fit: Flutter.BoxFit.cover)),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
            endDrawer: Flutter.Directionality(
              textDirection: Flutter.TextDirection.rtl,
              child: Drawer(
                shape: const Flutter.RoundedRectangleBorder(
                    borderRadius: Flutter.BorderRadius.zero),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        StreamBuilder<List<UsersInformations>>(
                          stream: jobDetails(FirebaseAuth
                              .instance.currentUser!.uid
                              .toString()),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(
                                  'Something went wrong! ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              final userAccount = snapshot.data!;
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: userAccount
                                      .map(buildProfileCard)
                                      .toList(),
                                ),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountScreen(
                                  id: FirebaseAuth.instance.currentUser!.uid
                                      .toString(),
                                  fullName: '',
                                ),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.account_circle_rounded,
                            size: 28,
                          ),
                          title: const Text(
                            'حسابي',
                            style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            openWhatsApp();
                          },
                          leading: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            size: 28,
                          ),
                          title: const Text(
                            'اعلن لدينا',
                            style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                          ),
                        ),
                        const ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.rankingStar,
                            size: 28,
                          ),
                          title: Text(
                            'تقييم تطبيقنا',
                            style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AboutAppScreen()));
                          },
                          leading: const Icon(
                            Icons.info_outline_rounded,
                            size: 28,
                          ),
                          title: const Text(
                            'حول تطبيق المثابر',
                            style: TextStyle(fontSize: 12, fontFamily: 'Cairo'),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    title: const Center(
                                        child: Text(
                                      'تسجيل خروج',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w500),
                                    )),
                                    content: Container(
                                      height: 20,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: const Center(
                                          child: Text(
                                        'هل أنت متأكد من تسجيل الخروج ؟',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ),
                                    actions: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                elevation: 0,
                                              ),
                                              onPressed: () async {
                                                await FirebaseAuth.instance
                                                    .signOut()
                                                    .whenComplete(
                                                      () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SignInScreen(),
                                                        ),
                                                      ),
                                                    );
                                              },
                                              child: const Text(
                                                'نعم',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Cairo',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12.0,
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                elevation: 0,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'لا',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Cairo',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          },
                          leading: const FaIcon(
                            FontAwesomeIcons.signOut,
                            size: 28,
                          ),
                          title: const Text(
                            'خروج',
                            style: TextStyle(fontSize: 12, fontFamily: 'Cairo'),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                textDirection: Flutter.TextDirection.rtl,
                                'نسخة تطبيق المثابر:',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontFamily: 'Cairo'),
                              ),
                              Text(
                                '1.0.0',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 36,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(.1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded,
                            color: Colors.grey.withOpacity(.6)),
                        Expanded(
                          child: Flutter.Directionality(
                            textDirection: Flutter.TextDirection.rtl,
                            child: TextField(
                              controller: searchController,
                              keyboardType: TextInputType.text,
                              cursorHeight: 20,
                              cursorColor: Colors.deepPurpleAccent,
                              cursorRadius: const Radius.circular(4),
                              onChanged: (value) {
                                setState(
                                    () {}); // إعادة بناء الواجهة عندما يتغير البحث
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'إبحث عن عمل',
                                hintStyle: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.withOpacity(.4),
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Cairo'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: StreamBuilder<List<OffersData>>(
                      stream: readData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong! ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<OffersData> offer = snapshot.data!;

                          // تصفية النتائج بناءً على البحث
                          if (searchController.text.isNotEmpty) {
                            offer = offer.where((pub) {
                              final searchInput =
                                  searchController.text.trim().toLowerCase();
                              return pub.title
                                      .toLowerCase()
                                      .contains(searchInput) ||
                                  pub.description
                                      .toLowerCase()
                                      .contains(searchInput);
                            }).toList();
                          }

                          return SingleChildScrollView(
                            child: Column(
                              children: offer.map(buildOfferCard).toList(),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

Widget buildProfileCard(UsersInformations user) {
  return UserAccountsDrawerHeader(
    decoration: const BoxDecoration(color: kMainTitleColor),
    accountName: Text(user.fullName),
    accountEmail: Text(user.emailAddress),
    currentAccountPicture: CircleAvatar(
      backgroundImage: NetworkImage(user.profileImage),
      backgroundColor: Colors.white,
    ),
  );
}

Stream<List<OffersData>> readData() => FirebaseFirestore.instance
    .collection('offers')
    .orderBy('publish_date', descending: true)
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => OffersData.fromJson(doc.data())).toList());
Stream<List<UsersInformations>> jobDetails(String docId) =>
    FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return [UsersInformations.fromJson((snapshot.data()!))];
      } else {
        return [];
      }
    });
