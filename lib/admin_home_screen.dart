import 'package:almuthaber_app/constants/colors_app.dart';
import 'package:almuthaber_app/data/models/offers_data.dart';
import 'package:almuthaber_app/data/models/usersInformations.dart';
import 'package:almuthaber_app/job_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart' as Flutter;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminHomeScreen extends StatefulWidget {
  AdminHomeScreen({required this.isPubPaid});

  final bool isPubPaid;

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Stream<List<OffersData>> readData() => FirebaseFirestore.instance
      .collection('offers')
      .where('publicity', isEqualTo: widget.isPubPaid)
      .orderBy('publish_date', descending: false)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => OffersData.fromJson(doc.data())).toList());

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
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailsScreen(
                id: offer.id,
                title: offer.title,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
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
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 18.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo'),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                offer.description,
                textAlign: TextAlign.right,
                textDirection: Flutter.TextDirection.rtl,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 10.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w200,
                    fontFamily: 'Cairo'),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                title: Center(
                                    child: Text(
                                  'حذف الاعلان',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cairo'),
                                )),
                                content: Container(
                                  height: 30,
                                  child: Center(
                                      child: Text(
                                    'هل تريد حذف هذا الاعلان ؟',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Cairo',
                                        color: Colors.black87),
                                  )),
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                backgroundColor:
                                                    kMainTitleColor),
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('offers')
                                                  .doc(offer.id)
                                                  .delete();

                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'نعم',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Cairo',
                                                  color: Colors.white),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 16.0,
                                      ),
                                      Expanded(
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 0.0,
                                                  backgroundColor:
                                                      kSecondButtonsColors),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'لا',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Cairo',
                                                    color: Colors.white),
                                              ))),
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 24,
                        color: kMainIconsColors,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat.yMMMMd('en_US')
                            .format(DateTime.parse(offer.publishingDate)),
                        textAlign: TextAlign.right,
                        textDirection: Flutter.TextDirection.rtl,
                        style: TextStyle(
                            fontSize: 8.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w200,
                            fontFamily: 'Cairo'),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        offer.city,
                        style: TextStyle(
                            fontSize: 8.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w200,
                            fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
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
              iconTheme: IconThemeData(color: Colors.black87),
              title: Text(
                'قسم الإعلانات',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Cairo',
                    color: Colors.black87),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
                          child: Directionality(
                            textDirection: Flutter.TextDirection.rtl,
                            child: TextField(
                              controller: searchController,
                              keyboardType: TextInputType.text,
                              cursorHeight: 20,
                              cursorColor: Colors.deepPurpleAccent,
                              cursorRadius: Radius.circular(4),
                              onChanged: (value) {
                                setState(
                                    () {}); // إعادة بناء الواجهة عندما يتغير البحث
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'إبحث عن إعلان',
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
                  SizedBox(height: 16.0),
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
