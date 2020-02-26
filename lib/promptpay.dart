library promptpay;

import 'dart:convert';
import 'dart:core';

import 'package:crclib/crclib.dart';

const versionID = "00";
const qrTypeID = "01";
const merchantAccountID = "29";
const subMerchantApplicationID = "00";
const subMerchantAccountPhoneID = "01";
const subMerchantAccountIdentityID = "02";
const subMerchantAccountEWalletID = "03";
const countryID = "58";
const currencyID = "53";
const amountID = "54";
const checksumID = "63";

const versionLength = "02";
const qrTypeLength = "02";
const merchantAccountLength = "37";
const subMerchantApplicationIDLength = "16";
const subMerchantAccountLength = "13";
const countryLength = "02";
const currencyLength = "03";
const checksumLength = "04";

const versionData = "01";
const qrMultipleTypeData = "11";
const qrOneTimeTypeData = "12";
const applicationIDData = "A000000677010111";
const countryData = "TH";
const bahtCurrencyData = "764";

enum TargetAccount { phone, identityNumber, eWallet }

/// A PromptPay is a payment method in Thailand
class PromptPay {
  /// Returns [QR Code Data] for PromptPay QR code
  static String generateQRData(String target, double amount) {
    TargetAccount targetAccount = target.length >= 15
        ? (TargetAccount.eWallet)
        : target.length >= 13
            ? (TargetAccount.identityNumber)
            : (TargetAccount.phone);

    var data = [
      versionID,
      versionLength,
      versionData,
      qrTypeID,
      qrTypeLength,
      qrMultipleTypeData,
      merchantAccountID,
      merchantAccountLength,
      subMerchantApplicationID,
      subMerchantApplicationIDLength,
      applicationIDData,
      _getAccountID(targetAccount),
      _getAccountLength(targetAccount, target),
      _formatAccount(targetAccount, target),
      countryID,
      countryLength,
      countryData,
      currencyID,
      currencyLength,
      bahtCurrencyData,
      amountID,
      _formatAmount(amount).length.toString().padLeft(2, '0'),
      _formatAmount(amount),
      checksumID,
      checksumLength
    ];

    var checksum =
        _getCrc16XMODEM().convert(utf8.encode(data.join())).toRadixString(16);

    return data.join() + checksum;
  }

  static String _getAccountID(TargetAccount targetAccount) {
    switch (targetAccount) {
      case TargetAccount.eWallet:
        return subMerchantAccountEWalletID;
      case TargetAccount.identityNumber:
        return subMerchantAccountIdentityID;
      default:
        return subMerchantAccountPhoneID;
    }
  }

  static String _getAccountLength(TargetAccount targetAccount, String target) {
    switch (targetAccount) {
      case TargetAccount.eWallet:
        return target.length.toString();
      case TargetAccount.identityNumber:
        return target.length.toString();
      default:
        return ("0066" + target.substring(1, target.length)).length.toString();
    }
  }

  static String _formatAccount(TargetAccount targetAccount, String target) {
    switch (targetAccount) {
      case TargetAccount.eWallet:
        return target;
      case TargetAccount.identityNumber:
        return target;
      default:
        return "0066" + target.substring(1, target.length);
    }
  }

  static String _formatAmount(double amount) {
    return amount.toStringAsFixed(2);
  }

  static ParametricCrc _getCrc16XMODEM() {
    // width=16 poly=0x1021 init=0x0000 refin=false refout=false xorout=0x0000 check=0x31c3 residue=0x0000 name="CRC-16/XMODEM"
    return new ParametricCrc(16, 0x1021, 0xFFFF, 0x0000,
        inputReflected: false, outputReflected: false);
  }
}
