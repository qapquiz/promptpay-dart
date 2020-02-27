import 'package:promptpay/promptpay.dart';

var promptpayDataWithAmount = PromptPay.generateQRData("0812345678", amount: 123.53);
var promptpayDataWithoutAmount = PromptPay.generateQRData("0812345678");
