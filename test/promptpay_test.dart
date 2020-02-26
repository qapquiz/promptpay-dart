import 'package:flutter_test/flutter_test.dart';

import 'dart:core';
import 'package:promptpay/promptpay.dart';

void main() {
  test('toString 3 must be 03', () {
    expect(3.toString().padLeft(2, '0'), "03");
  });
  test('should generate promptpay data for phone number correctly', () {
    expect(PromptPay.generateQRData("0000000000", 123.45), "00020101021129370016A000000677010111011300660000000005802TH53037645406123.456304b0b2");
  });

  test('should generate promptpay data for identity correctly', () {
    expect(PromptPay.generateQRData("0000000000000", 123.45), "00020101021129370016A000000677010111021300000000000005802TH53037645406123.4563046dcc");
  });

  test('should generate promptpay data for e-wallet correctly', () {
    expect(PromptPay.generateQRData("000000000000000", 123.45), "00020101021129370016A00000067701011103150000000000000005802TH53037645406123.456304ae16");
  });
}
