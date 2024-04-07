import 'dart:async';

import 'package:almuthaber_app/admin_screen.dart';
import 'package:almuthaber_app/constants/colors_app.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final emailAddressController = TextEditingController();

  final passwordController = TextEditingController();

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: _connectionStatus.toString() == 'ConnectivityResult.none'
          ? Center(
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
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 84,
                    width: 84,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: AssetImage('images/logo.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey.withOpacity(.1)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.email_rounded,
                          color: Colors.grey.withOpacity(.6),
                        ),
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
                                hintText: 'البريد الإلكتروني',
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
                        Icon(
                          Icons.lock_rounded,
                          color: Colors.grey.withOpacity(.6),
                        ),
                        Expanded(
                            child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            cursorHeight: 20,
                            cursorColor: Colors.deepPurpleAccent,
                            cursorRadius: Radius.circular(4),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'كلمة المرور',
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
                      if (emailAddressController.text ==
                              'admin@almutheber.com' &&
                          passwordController.text == 'admin123510') {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailAddressController.text,
                            password: passwordController.text,
                          );
                          // Handle successful sign-in
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                              content: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: CupertinoColors.activeGreen),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'تمت عملية الدخول بنجاح',
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          Timer(
                              const Duration(seconds: 2),
                              () => Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AdminScreen(),
                                    ),
                                  ));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            // Handle if the user is not found
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'لا يوجد اي حساب بهذه البيانات',
                                ),
                              ),
                            );
                          } else if (e.code == 'wrong-password') {
                            // Handle if the password is incorrect
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'كلمة المرور خاطئة',
                              ),
                            ));
                          } else {
                            // Handle other errors
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'فشل عملية الدخول تأكد من صلاحية البريد الإلكتروني وكلمة المرور',
                              ),
                            ));
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            'هذا الحساب لا يخولك الدخول الى لوحة التحكم؛ رجاءا تأكد من بيانات الدخول كمدير',
                          ),
                        ));
                      }
                    },
                    child: Text(
                      'سجل الدخول',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
