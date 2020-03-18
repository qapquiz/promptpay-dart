import 'dart:convert';

import 'package:either_option/either_option.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:core';
import 'package:promptpay/promptpay.dart';
import 'package:promptpay/promptpay_data.dart';

void main() {
  test('toString 3 must be 03', () {
    expect(3.toString().padLeft(2, '0'), "03");
  });
  test('generate qr data without amount', () {
    expect(PromptPay.generateQRData("0000000000"), "00020101021129370016A000000677010111011300660000000005802TH530376463048956");
  });
  test('should generate promptpay data for phone number correctly', () {
    expect(PromptPay.generateQRData("0812345678", amount: 123.45), "00020101021129370016A000000677010111011300668123456785802TH53037645406123.4563043045");
  });
  test('should generate promptpay data for identity correctly', () {
    expect(PromptPay.generateQRData("1100599000373", amount: 123.45), "00020101021129370016A000000677010111021300000000000005802TH53037645406123.4563046DCC");
  });

  test('should generate promptpay data for e-wallet correctly', () {
    expect(PromptPay.generateQRData("000000000000000", amount: 123.45), "00020101021129370016A00000067701011103150000000000000005802TH53037645406123.456304AE16");
  });

  test('qr data should be valid', () {
    final qrData = "00020101021129370016A000000677010111011300668123456785802TH53037645406123.4563043045";
    expect(PromptPay.isQRDataValid(qrData), true);
  });

  test('it is not qr data should not be valid', () {
    final notQRData = "31902380129830197401412890841209";
    expect(PromptPay.isQRDataValid(notQRData), false);
  });

  test('it is not qr data because length < 8', () {
    final notQRData = "1231356";
    expect(PromptPay.isQRDataValid(notQRData), false);
  });

  test('extract qrcode from qr data', () {
    final qrData = "00020101021129370016A000000677010111011300668123456785802TH53037645406123.4563043045";
    final indexOfStartApplicationData = qrData.indexOf(applicationIDData);
    
    expect(indexOfStartApplicationData, 20);
    expect(qrData[indexOfStartApplicationData], "A");

    final indexOfStartAccountType = indexOfStartApplicationData + applicationIDData.length;
    
    expect(indexOfStartAccountType, 36);

    final accountTypeString = qrData.substring(indexOfStartAccountType, indexOfStartAccountType + 2);

    expect(accountTypeString, "01");

    final accountType = accountTypeString == "01"
      ? AccountType.phone : accountTypeString == "02"
      ? AccountType.identityNumber : AccountType.eWallet;

    expect(accountType, AccountType.phone);

    final indexOfStartAccountLength = indexOfStartAccountType + 2;
    final accountLength = int.parse(qrData.substring(indexOfStartAccountLength, indexOfStartAccountLength + 2));

    expect(accountLength, 13);

    final indexOfStartAccountData = indexOfStartAccountLength + 2;
    final accountData = qrData.substring(indexOfStartAccountData, indexOfStartAccountData + accountLength);

    expect(accountData, "0066812345678");
  });

  test('extract qrcode from qr data with function', () {
    final qrData = "00020101021129370016A000000677010111011300668123456785802TH53037645406123.4563043045";
    expect(PromptPay.getAccountNumberFromQRData(qrData), Option.of("0066812345678"));
  });

  test('test promptpay constructor', () {
    final qrData = "00020101021129370016A000000677010111011300668123456785802TH53037645406123.4563043045";
    var promptPayData = PromptPayData.fromQRData(qrData);
    expect(promptPayData.emvcoVersion.type, PromptPayFieldType.EMVCoVersion);
    expect(promptPayData.emvcoVersion.length, 2);
    expect(promptPayData.emvcoVersion.data, "01");
    
    expect(promptPayData.qrType.type, PromptPayFieldType.qrType);
    expect(promptPayData.qrType.length, 2);
    expect(promptPayData.qrType.data, "11");

    expect(promptPayData.transferring.type, PromptPayFieldType.transferring);
    expect(promptPayData.transferring.length, 37);
    expect(promptPayData.transferring.data, "0016A00000067701011101130066812345678");
  });
}