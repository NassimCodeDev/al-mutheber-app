import 'package:almuthaber_app/account_screen.dart';
import 'package:almuthaber_app/constants/colors_app.dart';
import 'package:almuthaber_app/data/models/usersInformations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UsersDataScreen extends StatefulWidget {
  UsersDataScreen({this.isVisitor = false});
  bool isVisitor;

  @override
  _UsersDataScreenState createState() => _UsersDataScreenState();
}

class _UsersDataScreenState extends State<UsersDataScreen> {
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

  void openWhatsApp() async {
    String whatsappUrl = "https://wa.me/+249913279549";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  Widget buildAccountCard(UsersInformations account) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.1)),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              account.fullName,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                            Text(
                              account.domaine,
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              account.city,
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(
                              account.description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.grey,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(account.profileImage),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
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
                        fixedSize: Size(90, 36),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountScreen(
                            id: account.id,
                            fullName: account.fullName,
                            isVisitor: widget.isVisitor,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'إطلع',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: Colors.white),
                    )))
          ],
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
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
                'قسم التوظيف',
                style: TextStyle(
                    fontFamily: 'Cairo', fontSize: 14, color: Colors.black87),
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      openWhatsApp();
                    },
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.indigo),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage(
                              'images/whatsapp.png',
                            ),
                            height: 54,
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Expanded(
                            child: Text(
                              textDirection: TextDirection.rtl,
                              'لم تجد الشخص المناسب؟ تواصل معنا لنشر إعلانك !',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontFamily: 'Cairo'),
                            ),
                          )
                        ],
                      ),
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
                      color: Colors.grey.withOpacity(.1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Colors.grey.withOpacity(.6),
                        ),
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
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
                                hintText: 'إبحث عن مؤهلين',
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
                    child: StreamBuilder<List<UsersInformations>>(
                      stream: readData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong! ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<UsersInformations> userAccount = snapshot.data!;

                          // تصفية النتائج بناءً على البحث
                          if (searchController.text.isNotEmpty) {
                            userAccount = userAccount.where((user) {
                              final searchInput =
                                  searchController.text.trim().toLowerCase();
                              return user.fullName
                                      .toLowerCase()
                                      .contains(searchInput) ||
                                  user.domaine
                                      .toLowerCase()
                                      .contains(searchInput);
                            }).toList();
                          }

                          return SingleChildScrollView(
                            child: Column(
                              children:
                                  userAccount.map(buildAccountCard).toList(),
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

Stream<List<UsersInformations>> readData() => FirebaseFirestore.instance
    .collection('users')
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => UsersInformations.fromJson(doc.data()))
        .toList());
