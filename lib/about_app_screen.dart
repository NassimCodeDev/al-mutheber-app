import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Text(
            '''تطبيق المثابر
هو عبارة عن تطبيق ومنصة الكترونية مبتكرة تقوم بتوفير وظائف تدريس شاغرة للباحثين عن عمل في هذا المجال بسهولة وفاعلية.

تطبيق و موقع المثابر ليس شركة توظيف أو مكتب عمل ، بل عبارة عن منصة وسيطة تقوم بجمع الوظائف ونشرها.

توجد الكثير من المدارس داخل دولة الإمارات العربية المتحدة تتعاون مع المثابر بشكل مباشر لنشر وظائفهم الشاغرة.

مميزات التطبيق:
* التخصص:
هو عبارة عن تطبيق متخصص يقوم بجمع وتوفير وظائف شاغرة في مجال التدريس فقط.

* تصفح سهل وفعّال: 
يتميز تطبيق المثابر تجربة تصفح بسيطة و واجهة سهلة الاستخدام تتيح للمستخدمين العثور بسرعة على الوظائف التي تتناسب مع مهاراتهم واهتماماتهم.
''',
            style: TextStyle(fontFamily: 'Cairo', height: 1.8),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }
}
