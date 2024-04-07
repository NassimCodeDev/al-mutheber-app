import 'dart:convert';

import 'package:almuthaber_app/api/notifications_services.dart';
import 'package:almuthaber_app/constants/colors_app.dart';
import 'package:almuthaber_app/data/models/offers_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddOfferScreen extends StatefulWidget {
  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final titleOfferController = TextEditingController();

  final descriptionOfferController = TextEditingController();

  final phoneNumberController = TextEditingController();

  final emailAddressController = TextEditingController();

  String selectedCity = 'أبو ظبي';

  List<String> cities = [
    'أبو ظبي',
    'دبي',
    'الشارقة',
    'عجمان',
    'رأس الخيمة',
    'الفجيرة',
    'أم القيوين',
  ];

  NotificationsServices notificationsServices = NotificationsServices();

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
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return _connectionStatus.toString() == 'ConnectivityResult.none'
        ? Scaffold(
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
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.black87),
              centerTitle: true,
              title: Text(
                'إضافة إعلان وظيفة',
                style: TextStyle(
                    fontSize: 14, color: Colors.black87, fontFamily: 'Cairo'),
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.withOpacity(.1)),
                      child: Row(
                        children: [
                          Icon(Icons.note_alt_rounded,
                              color: Colors.grey.withOpacity(.6)),
                          Expanded(
                              child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: titleOfferController,
                              keyboardType: TextInputType.emailAddress,
                              cursorHeight: 20,
                              cursorColor: Colors.deepPurpleAccent,
                              cursorRadius: Radius.circular(4),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'العنوان',
                                  hintStyle: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.withOpacity(.4),
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Cairo')),
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.withOpacity(.1)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: descriptionOfferController,
                              maxLines: 100,
                              keyboardType: TextInputType.emailAddress,
                              cursorHeight: 20,
                              cursorColor: Colors.deepPurpleAccent,
                              cursorRadius: Radius.circular(4),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'المحتوى',
                                  hintStyle: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.withOpacity(.4),
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Cairo')),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.withOpacity(.1)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: DropdownButton<String>(
                                value: selectedCity,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                underline: Container(
                                  height: 0,
                                ),
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 10,
                                    fontFamily: 'Cairo'),
                                isExpanded: true, // تعيين هذه القيمة لـ true
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCity = newValue!;
                                  });
                                },
                                items: cities.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(value),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.withOpacity(.1)),
                      child: Row(
                        children: [
                          Icon(Icons.phone_rounded,
                              color: Colors.grey.withOpacity(.6)),
                          Expanded(
                              child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: phoneNumberController,
                              keyboardType: TextInputType.number,
                              cursorHeight: 20,
                              cursorColor: Colors.deepPurpleAccent,
                              cursorRadius: Radius.circular(4),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      '**** *** ** 971+ رقم الهاتف دون الرمز الدولي',
                                  hintStyle: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.withOpacity(.4),
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Cairo')),
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.withOpacity(.1)),
                      child: Row(
                        children: [
                          Icon(Icons.email_rounded,
                              color: Colors.grey.withOpacity(.6)),
                          Expanded(
                              child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: emailAddressController,
                              keyboardType: TextInputType.emailAddress,
                              cursorHeight: 20,
                              cursorColor: Colors.deepPurpleAccent,
                              cursorRadius: Radius.circular(4),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'البريد الإلكتروني *اختياري',
                                  hintStyle: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.withOpacity(.4),
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Cairo')),
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kMainTitleColor,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          fixedSize: Size(double.maxFinite, 48.0)),
                      onPressed: () async {
                        final createOffer = OffersData(
                          title: titleOfferController.text,
                          description: descriptionOfferController.text,
                          city: selectedCity,
                          publishingDate: DateTime.now().toString(),
                          pubActivePaid: false,
                          phoneNumber: phoneNumberController.text,
                          emailAddress: emailAddressController.text,
                        );
                        createNewOffers(createOffer);
                        notificationsServices
                            .getDeviceToken()
                            .then((value) async {
                          var data = {
                            'to': '/topics/all_users',
                            'priority': 'high',
                            'notification': {
                              'title': 'وظيفة جديدة',
                              'body':
                                  'تفقد تطبيق المثابر هناك وظيفة جديدة نتمنى لك حظا موفقا',
                            },
                            'data': {
                              'type': 'وظيفة جديدة',
                            }
                          };

                          var headers = {
                            'Content-Type': 'application/json',
                            'Authorization':
                                'key=AAAADSUDNBg:APA91bFBzuPmX7S6RyfmUMh2oRy_HULCOZVWtwCklP8tu2kP4Ksg2A1e09Fi5IUKNEwpyK5ETBOmsfJzWA83KG-Szu0e69NNMsJMOkvr9Qv6_iy2byZv-Wixxey5LyEaeTGdX6TUxU4a',
                          };

                          var response = await http.post(
                            Uri.parse('https://fcm.googleapis.com/fcm/send'),
                            body: jsonEncode(data),
                            headers: headers,
                          );

                          if (response.statusCode == 200) {
                            print('تم إرسال الإشعار بنجاح.');
                          } else {
                            print(
                                'فشل في إرسال الإشعار. الخطأ: ${response.statusCode}');
                          }
                        });

                        titleOfferController.clear();
                        descriptionOfferController.clear();
                        phoneNumberController.clear();
                        emailAddressController.clear();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Center(child: Text('تمت اضافة العرض'))));
                      },
                      child: Text(
                        'نشر واضافة العرض لقاعدة البيانات',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                            fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kMainButtonsColors,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          fixedSize: Size(double.maxFinite, 48.0)),
                      onPressed: () {
                        final createOffer = OffersData(
                          title: titleOfferController.text,
                          description: descriptionOfferController.text,
                          city: selectedCity,
                          publishingDate: DateTime.now().toString(),
                          pubActivePaid: true,
                          phoneNumber: phoneNumberController.text,
                          emailAddress: emailAddressController.text,
                        );
                        createNewOffers(createOffer);
                        titleOfferController.clear();
                        descriptionOfferController.clear();
                        phoneNumberController.clear();
                        emailAddressController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Center(child: Text('تمت اضافة العرض'))));
                      },
                      child: Text(
                        'اعلان مدفوع لشركة او جهة حكومية',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

Future<void> createNewOffers(OffersData offer) async {
  final docUser = FirebaseFirestore.instance.collection('offers').doc();
  offer.id = docUser.id;
  final json = offer.toJson();
  await docUser.set(json);
}
