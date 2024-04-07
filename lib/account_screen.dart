import 'package:almuthaber_app/data/models/usersInformations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants/colors_app.dart';

class AccountScreen extends StatefulWidget {
  final String id;
  final String fullName;
  bool isVisitor;

  AccountScreen(
      {required this.id, required this.fullName, this.isVisitor = false});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final fullNameController = TextEditingController();

  final domaineController = TextEditingController();

  final emailAddressController = TextEditingController();

  final phoneNumberController = TextEditingController();

  final descriptionController = TextEditingController();

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

  Stream<List<UsersInformations>> accountData(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return [UsersInformations.fromJson((snapshot.data()!))];
        } else {
          return [];
        }
      });

  @override
  Widget build(BuildContext context) {
    Widget buildAccountUiScreen(UsersInformations account) {
      void openWhatsApp() async {
        String whatsappUrl = "https://wa.me/+971${account.phoneNumber}";
        if (await canLaunch(whatsappUrl)) {
          await launch(whatsappUrl);
        } else {
          throw 'Could not launch $whatsappUrl';
        }
      }

      void openMail() async {
        String email = '${account.emailAddress}';
        String subject = 'Subject of the email';
        String body = 'Body of the email';

        String? encodeQueryParameters(Map<String, String> params) {
          return params.entries
              .map((MapEntry<String, String> e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
              .join('&');
        }

// ···
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: email,
          query: encodeQueryParameters(<String, String>{
            'subject': 'Example Subject & Symbols are allowed!',
          }),
        );

        launchUrl(emailLaunchUri);
      }

      Future<void> openFile() async {
        if (await canLaunch(account.cvFile)) {
          await launch(account.cvFile);
        } else {
          throw 'Could not launch ${account.cvFile}';
        }
      }

      return Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(account.profileImage),
              radius: 40,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              account.fullName,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              account.domaine,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              account.city,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    openWhatsApp();
                  },
                  icon: Icon(Icons.phone_rounded),
                ),
                IconButton(
                  onPressed: () {
                    openMail();
                  },
                  icon: Icon(
                    Icons.email_rounded,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              width: double.maxFinite,
              height: 300,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    account.description,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 12),
                  )
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
                  fixedSize: Size(MediaQuery.of(context).size.width, 48)),
              onPressed: () {
                openFile();
              },
              child: Text(
                'تحميل السيرة الذاتية',
                style: TextStyle(
                    fontSize: 10, fontFamily: 'Cairo', color: Colors.white),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Visibility(
              visible: !widget.isVisitor,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSecondButtonsColors,
                  elevation: 0.0,
                  fixedSize: Size(MediaQuery.of(context).size.width, 48),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            content: SizedBox(
                              height: 520,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      height: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.grey.withOpacity(.1)),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person_rounded,
                                            color: kInactiveIconsColors,
                                            size: 22,
                                          ),
                                          Expanded(
                                              child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: TextField(
                                              controller: fullNameController,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              keyboardType: TextInputType.text,
                                              cursorHeight: 20,
                                              cursorColor:
                                                  Colors.deepPurpleAccent,
                                              cursorRadius:
                                                  const Radius.circular(4),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'الإسم الكامل',
                                                  hintStyle: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey
                                                          .withOpacity(.4),
                                                      fontStyle:
                                                          FontStyle.italic,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      height: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.grey.withOpacity(.1)),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.work_rounded,
                                            color: kInactiveIconsColors,
                                            size: 22,
                                          ),
                                          Expanded(
                                              child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: TextField(
                                              controller: domaineController,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              keyboardType: TextInputType.text,
                                              cursorHeight: 20,
                                              cursorColor:
                                                  Colors.deepPurpleAccent,
                                              cursorRadius:
                                                  const Radius.circular(4),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'التخص الدراسي أو المهني',
                                                  hintStyle: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey
                                                          .withOpacity(.4),
                                                      fontStyle:
                                                          FontStyle.italic,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      height: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.grey.withOpacity(.1)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: DropdownButton<String>(
                                                value: selectedCity,
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                iconSize: 24,
                                                elevation: 16,
                                                underline: Container(
                                                  height: 0,
                                                ),
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 10,
                                                    fontFamily: 'Cairo'),
                                                isExpanded:
                                                    true, // تعيين هذه القيمة لـ true
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedCity = newValue!;
                                                  });
                                                },
                                                items: cities.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16),
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
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      height: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.grey.withOpacity(.1)),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.phone_rounded,
                                            color: kInactiveIconsColors,
                                            size: 22,
                                          ),
                                          Expanded(
                                              child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: TextField(
                                              controller: phoneNumberController,
                                              keyboardType: TextInputType.phone,
                                              cursorHeight: 20,
                                              cursorColor:
                                                  Colors.deepPurpleAccent,
                                              cursorRadius:
                                                  const Radius.circular(4),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      '**** *** ** 971+ رقم الهاتف دون الرمز الدولي',
                                                  hintStyle: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey
                                                          .withOpacity(.4),
                                                      fontStyle:
                                                          FontStyle.italic,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      height: 200,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.grey.withOpacity(.1)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: TextField(
                                              controller: descriptionController,
                                              keyboardType: TextInputType.text,
                                              maxLines: 20,
                                              cursorHeight: 20,
                                              cursorColor:
                                                  Colors.deepPurpleAccent,
                                              cursorRadius:
                                                  const Radius.circular(4),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'نبذة عن السيرة الذاتية',
                                                  hintStyle: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey
                                                          .withOpacity(.4),
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontFamily: 'Cairo')),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: kMainButtonsColors,
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          fixedSize: const Size(
                                              double.maxFinite, 48.0)),
                                      onPressed: () async {
                                        // Check if the field is not null and not an empty string
                                        bool isNotEmpty(String value) {
                                          return value != null &&
                                              value.isNotEmpty;
                                        }

                                        // Create a map to store the fields that need to be updated
                                        Map<String, dynamic> dataToUpdate = {};

                                        // Check and add fields to the update map if they are not empty
                                        if (isNotEmpty(
                                            fullNameController.text)) {
                                          dataToUpdate['full_name'] =
                                              fullNameController.text;
                                        }

                                        if (isNotEmpty(
                                            domaineController.text)) {
                                          dataToUpdate['domaine'] =
                                              domaineController.text;
                                        }

                                        if (isNotEmpty(selectedCity)) {
                                          dataToUpdate['city'] = selectedCity;
                                        }

                                        if (isNotEmpty(
                                            phoneNumberController.text)) {
                                          dataToUpdate['phone_number'] =
                                              phoneNumberController.text;
                                        }

                                        if (isNotEmpty(
                                            descriptionController.text)) {
                                          dataToUpdate['description'] =
                                              descriptionController.text;
                                        }

                                        // Perform the update operation if there are fields to update
                                        if (dataToUpdate.isNotEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(account.id)
                                              .update(dataToUpdate);
                                        }
                                        fullNameController.clear();
                                        domaineController.clear();

                                        selectedCity = account.city;

                                        phoneNumberController.clear();
                                        descriptionController.clear();
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'تحديث البيانات',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Cairo'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      });
                },
                child: Text(
                  'تحديث البيانات',
                  style: TextStyle(
                      fontSize: 10, fontFamily: 'Cairo', color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          widget.fullName,
          style: TextStyle(
              fontSize: 16, fontFamily: 'Cairo', color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: StreamBuilder<List<UsersInformations>>(
          stream: accountData(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final userAccount = snapshot.data!;
              return SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: userAccount.map(buildAccountUiScreen).toList(),
              ));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
