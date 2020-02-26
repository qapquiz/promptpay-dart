import 'package:flutter_test/flutter_test.dart';

import 'dart:core';
import 'package:promptpay/promptpay.dart';

void main() {
  test('toString 3 must be 03', () {
    expect(3.toString().padLeft(2, '0'), "03");
  });
  test('should generate promptpay data for identity correctly', () {
    expect(PromptPay.generateQRData("0000000000", 123.45), "00020101021129370016A000000677010111011300660000000005802TH53037645406123.456304b0b2");
  });
}
