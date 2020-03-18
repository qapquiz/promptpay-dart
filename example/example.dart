import 'package:promptpay/promptpay.dart';

var promptpayDataWithAmount = PromptPay.generateQRData("0812345678", amount: 123.53);
var promptpayDataWithoutAmount = PromptPay.generateQRData("0812345678");

final qrData = "00020101021129370016A000000677010111011300668123456785802TH53037645406123.4563043045";
var accountNumber = PromptPay.getAccountNumberFromQRData(qrData);

// add amount to existing qr code
final newQRCode = PromptPay.getPromptPayQRWithNewAmount("00020101021129370016A000000677010111011300668123456785802TH53037645406123.4563043045", 200.04);

// check is this valid as a QR promptpay
bool isQRValid = PromptPay.isQRDataValid(qrData);