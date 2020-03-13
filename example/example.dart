import 'package:promptpay/promptpay.dart';

var promptpayDataWithAmount = PromptPay.generateQRData("0812345678", amount: 123.53);
var promptpayDataWithoutAmount = PromptPay.generateQRData("0812345678");

final qrData = "00020101021129370016A000000677010111011300668123456785802TH53037645406123.4563043045";
var accountNmuber = PromptPay.getAccountNumberFromQRData(qrData);