import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailAddressController = TextEditingController();

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
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black87),
              title: Text(
                'إستعادة كلمة المرور',
                style: TextStyle(
                    fontSize: 14, color: Colors.black87, fontFamily: 'Cairo'),
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
                    height: 48,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey.withOpacity(.1)),
                    child: Row(
                      children: [
                        Expanded(
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
                              fontFamily: 'Cairo',
                            ),
                          ),
                        )),
                        Icon(
                          Icons.email_rounded,
                          color: Colors.grey.withOpacity(.2),
                          size: 22,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          6.0,
                        ),
                      ),
                      fixedSize: const Size(
                        double.maxFinite,
                        48.0,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: emailAddressController.text,
                        );
                        showSnackBar(context,
                            'تم إرسال رابط استعادة كلمة المرور الى بريدكم الإلكتروني.');
                      } catch (e) {
                        print('Error sending reset email: $e');
                        // Handle error, e.g., show error message
                      }
                    },
                    child: Text(
                      'أرسل',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 48,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.green,
          ),
          child: Text(
            message,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    );
  }
}
