import 'package:almuthaber_app/constants/colors_app.dart';
import 'package:almuthaber_app/data/models/offers_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as Flutter;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailsScreen extends StatelessWidget {
  final String id;
  final String title;
  JobDetailsScreen({
    required this.id,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(.5),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black87, fontSize: 14, fontFamily: 'Cairo'),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<OffersData>>(
        stream: jobDetails(id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final userAccount = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: userAccount.map(buildJobDetailsUIScreen).toList(),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Widget buildJobDetailsUIScreen(OffersData offer) {
  void openWhatsApp() async {
    String whatsappUrl = "https://wa.me/+971${offer.phoneNumber}";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  void openMail() async {
    String recipientEmail = '${offer.emailAddress}';
    String subject = 'أضف موضوع البريد الإلكتروني';
    String body = 'أضف محتوى البريد الإلكتروني';

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

// ···
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': body,
      }),
    );

    launchUrl(emailLaunchUri);
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              offer.title,
              textAlign: TextAlign.right,
              textDirection: Flutter.TextDirection.rtl,
              style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo'),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat.yMMMMd('ar')
                      .format(DateTime.parse(offer.publishingDate)),
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  offer.city,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          offer.description,
          textAlign: TextAlign.right,
          textDirection: Flutter.TextDirection.rtl,
          style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black87,
              fontWeight: FontWeight.w200,
              fontFamily: 'Cairo'),
        ),
        SizedBox(
          height: 16,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: kSecondButtonsColors,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  40,
                ),
              ),
              fixedSize: Size(double.maxFinite, 48),
              elevation: 0.0),
          onPressed: () {
            openMail();
          },
          child: Text(
            'راسلنا عبر البريد الإلكتروني',
            style: TextStyle(
                fontSize: 12, fontFamily: 'Cairo', color: Colors.white),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: CupertinoColors.activeGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  40,
                ),
              ),
              fixedSize: Size(double.maxFinite, 48),
              elevation: 0.0),
          onPressed: () {
            openWhatsApp();
          },
          child: Text(
            'راسلنا عبر الواتساب',
            style: TextStyle(
                fontSize: 12, fontFamily: 'Cairo', color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

Stream<List<OffersData>> jobDetails(String docId) => FirebaseFirestore.instance
        .collection('offers')
        .doc(docId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return [OffersData.fromJson((snapshot.data()!))];
      } else {
        return [];
      }
    });

class ClipWave extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double marginTop = 400;

    Path path = Path();

    path.moveTo(0, marginTop);
    path.cubicTo(width * 1 / 2, height / 6 + marginTop, width * 3 / 6,
        -(height / 6) + marginTop, width, marginTop);

    path.lineTo(width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
