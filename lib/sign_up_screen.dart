import 'dart:io';

import 'package:almuthaber_app/constants/colors_app.dart';
import 'package:almuthaber_app/constants/show_snack_bar.dart';
import 'package:almuthaber_app/data/models/usersInformations.dart';
import 'package:almuthaber_app/sign_in_screen.dart';
import 'package:almuthaber_app/stripe_payment/payment_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fullNameController = TextEditingController();

  final domaineController = TextEditingController();

  final emailAddressController = TextEditingController();

  final phoneNumberController = TextEditingController();

  final descriptionController = TextEditingController();

  final passwordController = TextEditingController();

  bool isAcceptedConditions = false;

  File? _profileImage;

  File? _cvFile;

  late final String profileImageLink;
  late final String cvFileLink;

  double _uploadProgress = 0.0;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _profileImage = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _pickDeplome() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _cvFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _uploadImage() async {
    if (_profileImage == null) {
      return;
    }

    try {
      final fileName = path.basename(_profileImage!.path);
      final storageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);

      // Show progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
                child: Text(
              'جاري رفع صورة الحساب',
              style: TextStyle(fontSize: 12, fontFamily: 'Cairo'),
            )),
            content: LinearProgressIndicator(
              value: _uploadProgress,
            ),
          );
        },
      );

      // Listen to the upload task
      firebase_storage.UploadTask task = storageRef.putFile(_profileImage!);
      task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      // Wait for the upload to complete
      await task;

      // Close progress dialog
      Navigator.of(context).pop();

      profileImageLink = await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _uploadDeplome() async {
    if (_cvFile == null) {
      return;
    }

    try {
      final fileName = path.basename(_cvFile!.path);
      final storageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);

      // Show progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'جاري رفع ملف السيرة الذاتية',
              style: TextStyle(fontSize: 12, fontFamily: 'Cairo'),
            ),
            content: LinearProgressIndicator(
              value: _uploadProgress,
            ),
          );
        },
      );

      // Listen to the upload task
      firebase_storage.UploadTask task = storageRef.putFile(_cvFile!);
      task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      // Wait for the upload to complete
      await task;

      // Close progress dialog
      Navigator.of(context).pop();

      cvFileLink = await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading document: $e');
    }
  }

  final controller = PageController(initialPage: 0);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
        iconTheme: const IconThemeData(color: Colors.black87),
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
          : PageView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 120),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تسجيل حساب جديد',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Cairo',
                              color: kMainTitleColor,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey.withOpacity(.1)),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_rounded,
                                color: kInactiveIconsColors,
                                size: 22,
                              ),
                              Expanded(
                                  child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  controller: fullNameController,
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text,
                                  cursorHeight: 20,
                                  cursorColor: Colors.deepPurpleAccent,
                                  cursorRadius: const Radius.circular(4),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'الإسم الكامل',
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
                              const Icon(
                                Icons.work_rounded,
                                color: kInactiveIconsColors,
                                size: 22,
                              ),
                              Expanded(
                                  child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  controller: domaineController,
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text,
                                  cursorHeight: 20,
                                  cursorColor: Colors.deepPurpleAccent,
                                  cursorRadius: const Radius.circular(4),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'التخصص الدراسي او المهني',
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
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    underline: Container(
                                      height: 0,
                                    ),
                                    style: const TextStyle(
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
                                    items: cities.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
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
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: _pickImage,
                              child: Container(
                                height: 72,
                                width: 72,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.withOpacity(.1),
                                    image: DecorationImage(
                                        image: _profileImage != null
                                            ? FileImage(
                                                _profileImage!,
                                              )
                                            : const AssetImage(
                                                    'images/background.jpg')
                                                as ImageProvider<Object>,
                                        fit: BoxFit.cover)),
                                child: _profileImage != null
                                    ? const Text('')
                                    : Text(
                                        textAlign: TextAlign.center,
                                        'إضافة صورة\nشخصية',
                                        style: TextStyle(
                                            fontSize: 8,
                                            color: Colors.grey.withOpacity(.4),
                                            fontFamily: 'Cairo'),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            InkWell(
                              onTap: _pickDeplome,
                              child: Container(
                                height: 72,
                                width: 72,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: kInactiveButtonsColors),
                                child: _cvFile != null
                                    ? const Icon(
                                        Icons.sticky_note_2_outlined,
                                        color: Colors.green,
                                      )
                                    : Text(
                                        textAlign: TextAlign.center,
                                        'إضافة ملف السيرة الذاتية',
                                        style: TextStyle(
                                            fontSize: 8,
                                            color: Colors.grey.withOpacity(.4),
                                            fontFamily: 'Cairo'),
                                      ),
                              ),
                            ),
                          ],
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
                              const Icon(
                                Icons.email_rounded,
                                color: kInactiveIconsColors,
                                size: 22,
                              ),
                              Expanded(
                                  child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  controller: emailAddressController,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorHeight: 20,
                                  cursorColor: Colors.deepPurpleAccent,
                                  cursorRadius: const Radius.circular(4),
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
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey.withOpacity(.1)),
                          child: Row(
                            children: [
                              const Icon(
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
                                  cursorColor: Colors.deepPurpleAccent,
                                  cursorRadius: const Radius.circular(4),
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
                        const SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
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
                                  cursorColor: Colors.deepPurpleAccent,
                                  cursorRadius: const Radius.circular(4),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'نبذة عن السيرة الذاتية',
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
                              const Icon(
                                Icons.lock_rounded,
                                color: kInactiveIconsColors,
                                size: 22,
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
                                  cursorRadius: const Radius.circular(4),
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
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              scrollable: true,
                                              content: Text(
                                                '''سياسة الخصوصية والاستخدام
    
    
    الخصوصية وبيان سريّة المعلومات
    نقدر مخاوفكم واهتمامكم بشأن خصوصية بياناتكم على شبكة الإنترنت.
    لقد تم إعداد هذه السياسة لمساعدتكم في تفهم طبيعة البيانات التي نقوم بتجميعها منكم عند التسجيل فى تطبيق المثابر  وكيفية تعاملنا مع هذه البيانات الشخصية.
    
    إفشاء المعلومات
    سنحافظ في كافة الأوقات على خصوصية وسرية كافة البيانات الشخصية التي نتحصل عليها. ولن يتم إفشاء هذه المعلومات إلا إذا كان ذلك مطلوباً بموجب أي قانون أو عندما نعتقد بحسن نية أن مثل هذا الإجراء سيكون مطلوباً أو مرغوباً فيه للتمشي مع القانون , أو للدفاع عن أو حماية حقوق الملكية الخاصة بهذا التطبيق أو الجهات المستفيدة منه.
    
    البيانات اللازمة لتنفيذ المعاملات المطلوبة من قبلك
    عندما نحتاج إلى أية بيانات خاصة بك , فإننا سنطلب منك تقديمها بمحض إرادتك. حيث ستساعدنا هذه المعلومات في الاتصال بك وتنفيذ طلباتك حيثما كان ذلك ممكنناً. لن يتم اطلاقاً بيع البيانات المقدمة من قبلك إلى أي طرف ثالث بغرض تسويقها لمصلحته الخاصة دون الحصول على موافقتك المسبقة والمكتوبة ما لم يتم ذلك على أساس أنها ضمن بيانات جماعية تستخدم للأغراض الإحصائية والأبحاث دون اشتمالها على أية بيانات من الممكن استخدامها للتعريف بك.
    
    عند الاتصال بنا
    سيتم التعامل مع كافة البيانات المقدمة من قبلك على أساس أنها سرية . تتطلب النماذج التي يتم تقديمها مباشرة على الشبكة تقديم البيانات التي ستساعدنا في تحسين تطبيقنا سيتم استخدام البيانات التي يتم تقديمها من قبلك في الرد على كافة استفساراتك , ملاحظاتك , أو طلباتك من قبل هذا التطبيقأو أيا من المواقع التابعة له .
    
    إفشاء المعلومات لأي طرف ثالث
    لن نقوم ببيع , المتاجرة , تأجير , أو إفشاء أية معلومات لمصلحة أي طرف ثالث خارج هذا التطبيق, أو المواقع التابعة له.وسيتم الكشف عن المعلومات فقط في حالة صدور أمر بذلك من قبل أي سلطة قضائية أو تنظيمية.
    
    التعديلات على سياسة سرية وخصوصية المعلومات
    نحتفظ بالحق في تعديل بنود وشروط سياسة سرية وخصوصية المعلومات إن لزم الأمر ومتى كان ذلك ملائماً. سيتم تنفيذ التعديلات هنا  وسيتم بصفة مستمرة إخطارك بالبيانات التي حصلنا عليها , وكيف سنستخدمها والجهة التي سنقوم بتزويدها بهذه البيانات.
    
    الاتصال بنا
    يمكنكم الاتصال بنا عند الحاجة من خلال الضغط على رابط اتصل بنا المتوفر في روابط موقعنا او الارسال الى بريدنا الالكتروني support@almuthaber.com على اسم النطاق اعلاه
    
    اخيرا
    إن مخاوفك واهتمامك بشأن سرية وخصوصية البيانات تعتبر مسألة في غاية الأهمية بالنسبة لنا. نحن نأمل أن يتم تحقيق ذلك من خلال هذه السياسة.
    
    
    
    إتفاقية الإستخدام:
     بإستعمالك لهذا التطبيق ، فإنك توافق على أن تتقيد وتلتزم بالشروط والأحكام التالية لذا، يرجى منك الاطلاع على هذه الأحكام بدقة. أن كنت لا توافق على هذه الأحكام، فعليك ألا تستمر فى عملية التسجيل.
    
    جميع الموارد الموجوده فى التطبيق معروضه "كما هى " بدون أى ضمانات واستخدامك للتطبيق خدماتها أو  الموجوده فيها على ؤوليتك الشخصيه فقط كما لا تلتزم الابداع التقنى أو ادارته بأى مسؤوليه أو تعويض عن أيه أخطاء ناتجه من استخدامك للتطبيق , احدى خدماته أو محتوياته ويخلي مسؤوليته من أي عقود أو اتفاقات جرت بشكل مستقل بين مستخدميه أو أي جهة أخرى.
    
    نعرض كذلك المنشورات  تحمل في مضمونها سيرا ذاتية لأشخاص، ورغم أني سأطلع على الشهادات والوثائق التي تبين المستوى والكفاءات إلا أني لا أضمن صحتها 100%، ومنه فإن أي مغالطات تقع على مسؤولية أصحابها.
    
    لا نتحمل مسؤولية الاضرار التي قد تكون ناتجة عن عدم حسن تطبيق بعض الشروحات.
    
    إستعمالك وتصفحك للتطبيق يعنى موافقتك الكامله على جميع الشروط الوارده فى هذه الصفحه , اذا كنت لا توافق على الشروط الموجوده فى هذه الصفحه لا يسمح لك تصفح التطبيق ومشاهدة محتوياته ويجب عليك التوقف عن استخدامه الان.
    
    
    الاشتراك  استرداد الأموال في تطبيق المثابر:
    تطبيق المثابر هو تطبيق خالي من الاعلانات ومبسط جدا في الاستخدام ويوفر الكثير من وظائف التدريس الشاغرة في جميع مناطق الأمارات بشكل لحظي وحصري، ويساعد الباحثين عن العمل في انشاء ملف تعريفي، ولذلك التطبيق يكون عبر الاشتراك فيه بمقابل مادي، وسوف يكون الاشتراك بالدرهم الاماراتي وسعر الاشتراك قابل للزيادة في اي وقت، وسوف نخبركم بهذا الخصوص.
    
    سياسات استرداد الأموال المدفوعة مقابل اشتراك في تطبيق المثابر:
    لا يمكنك إلغاء الاشتراك في تطبيق المثابر ورسوم الاشتراك غير قابلة للاسترداد.''',
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontFamily: 'Cairo'),
                                              ),
                                            );
                                          });
                                    },
                                    child: Text(
                                      'شروط الاستخدام والخصوصية',
                                      style: TextStyle(
                                          fontFamily: 'Cairo', fontSize: 12),
                                    )),
                                Text(
                                  'أوافق على',
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 10,
                                      color: Colors.deepPurple),
                                )
                              ],
                            ),
                            Checkbox(
                                value: isAcceptedConditions,
                                onChanged: (value) {
                                  setState(() {
                                    isAcceptedConditions = value!;
                                  });
                                })
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kMainTitleColor,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              fixedSize: const Size(double.maxFinite, 48.0)),
                          onPressed: () {
                            if (emailAddressController.text.isEmpty ||
                                domaineController.text.isEmpty ||
                                _profileImage == null ||
                                _cvFile == null ||
                                fullNameController.text.isEmpty ||
                                phoneNumberController.text.isEmpty ||
                                descriptionController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                isAcceptedConditions == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0.0,
                                  content: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: CupertinoColors.destructiveRed),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'رجاءا تأكد ان جميع الحقول قد تمت تعبأتها',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Cairo'),
                                        ),
                                        SizedBox(
                                          width: 12.0,
                                        ),
                                        Icon(
                                          Icons.warning_rounded,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .where('email_address',
                                      isEqualTo:
                                          '${emailAddressController.text}')
                                  .get()
                                  .then((querySnapshot) {
                                if (querySnapshot.docs.isNotEmpty) {
                                  // يوجد مستند بالفعل بنفس البريد الإلكتروني
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        title: Center(child: Text('تنبيه')),
                                        content: Container(
                                            alignment: Alignment.center,
                                            height: 40,
                                            child: Text(
                                                textDirection:
                                                    TextDirection.rtl,
                                                'هذا البريد الإلكتروني مسجل من قبل!')),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              elevation: 0.0,
                                              fixedSize:
                                                  Size(double.maxFinite, 48),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  4,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'حسنا',
                                              style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  controller.animateToPage(1,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeInOut);
                                }
                              });
                            }
                          },
                          child: const Text(
                            'تأكيد الإشتراك',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Cairo'),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/payment.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black87,
                            Colors.black87,
                            Colors.transparent
                          ])),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'تمكن من العثور على آلاف فرص العمل الحصرية بتطبيقنا.',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'إشتراك سنوي قيمته 36 درهم إماراتي فقط بما يعادل 3 دراهم إماراتية شهريا.',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kMainButtonsColors,
                                elevation: 0.0,
                                fixedSize: Size(double.maxFinite, 48),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6))),
                            onPressed: () {
                              PaymentManager.makePayment(36, 'AED')
                                  .then((value) async {
                                await _uploadImage().then((value) async {
                                  await _uploadDeplome().then((value) async {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: emailAddressController.text,
                                      password: passwordController.text,
                                    );
                                    final aUser = UsersInformations(
                                        fullName: fullNameController.text,
                                        domaine: domaineController.text,
                                        city: selectedCity,
                                        profileImage: profileImageLink,
                                        cvFile: cvFileLink,
                                        emailAddress:
                                            emailAddressController.text,
                                        phoneNumber: phoneNumberController.text,
                                        description: descriptionController.text,
                                        password: passwordController.text,
                                        subscriptionIsActive: true);
                                    createUsersData(aUser);
                                    showSnackBar(
                                        context,
                                        'تم تسجيل الحساب بنجاح',
                                        CupertinoColors.activeGreen);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignInScreen(),
                                      ),
                                    );
                                  });
                                });
                              });
                            },
                            child: Text(
                              'تأكيد الاشتراك & إتمام عملية التسجيل',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  fontSize: 10),
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kInactiveButtonsColors,
                                elevation: 0.0,
                                fixedSize: Size(double.maxFinite, 48),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6))),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'لديك حساب ؟ سجل الدخول',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Cairo',
                                  fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }
}

Future<void> createUsersData(UsersInformations userInfos) async {
  final docUser = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  userInfos.id = docUser.id;
  final json = userInfos.toJson();
  await docUser.set(json);
}
