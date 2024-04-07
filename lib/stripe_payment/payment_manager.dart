import 'package:almuthaber_app/stripe_payment/stripe_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

abstract class PaymentManager {
  static Future<void> makePayment(int amount, String currency) async {
    try {
      String clientSecret =
          await _getClientSecret((amount * 100).toString(), currency);
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'el muthaber',
      ),
    );
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ${ApiKeys.secretKeys}';
    dio.options.headers['Content-type'] = 'application/x-www-form-urlencoded';
    var response = await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      data: {
        'amount': amount,
        'currency': currency,
      },
    );
    return response.data['client_secret'];
  }
}
