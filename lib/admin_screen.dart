import 'package:almuthaber_app/add_offer_screen.dart';
import 'package:almuthaber_app/admin_home_screen.dart';
import 'package:almuthaber_app/constants/colors_app.dart';
import 'package:almuthaber_app/sign_in_screen.dart';
import 'package:almuthaber_app/users_data_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black87),
          centerTitle: true,
          title: Text(
            'لوحة التحكم',
            style: TextStyle(
                fontSize: 16, fontFamily: 'Cairo', color: Colors.black87),
          ),
          leading: Icon(
            Icons.dashboard_customize_rounded,
            color: kMainTitleColor,
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 400,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UsersDataScreen(),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(.1),
                      ),
                      child: Text(
                        'بيانات المستخدمين',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                            fontFamily: 'Cairo'),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminHomeScreen(isPubPaid: false),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(.1),
                      ),
                      child: Text(
                        'لائحة الإعلانات العامة',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                            fontFamily: 'Cairo'),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminHomeScreen(isPubPaid: true),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(.1),
                      ),
                      child: Text(
                        'الإعلانات المدفوعة',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                            fontFamily: 'Cairo'),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddOfferScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 180,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kMainTitleColor,
                      ),
                      child: Text(
                        'إضافة عرض',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontFamily: 'Cairo'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut().whenComplete(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                });
              },
              splashColor: Colors.transparent,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: kMainTitleColor,
                child: Icon(
                  Icons.stop_circle_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
