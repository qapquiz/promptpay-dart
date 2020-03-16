enum PromptPayFieldType {
	unknown,
	EMVCoVersion,
	qrType,
	transferring,
	transferringType,
	transferringPhoneNumber,
	transferringIdentityNumber,
	transferringEWallet,
	billing,
	billingType,
	billingID,
	billingReferenceNumber1,
	billingReferenceNumber2,
	country,
	currency,
	amount,
  unknownFieldTypeForBilling,
	checksum
}

class PromptPayField {
	static const _mapIDNumberWithField = {
		"00" : PromptPayFieldType.EMVCoVersion,
		"01" : PromptPayFieldType.qrType,
		"29" : PromptPayFieldType.transferring,
		"29_00" : PromptPayFieldType.transferringType,
		"29_01" : PromptPayFieldType.transferringPhoneNumber,
		"29_02" : PromptPayFieldType.transferringIdentityNumber,
		"29_03" : PromptPayFieldType.transferringEWallet,
		"30" : PromptPayFieldType.billing,
		"30_00" : PromptPayFieldType.billingType,
		"30_01" : PromptPayFieldType.billingID,
		"30_02" : PromptPayFieldType.billingReferenceNumber1,
		"30_03" : PromptPayFieldType.billingReferenceNumber2,
		"53" : PromptPayFieldType.currency,
		"54" : PromptPayFieldType.amount,
    "58" : PromptPayFieldType.country,
    "62" : PromptPayFieldType.unknownFieldTypeForBilling,
		"63" : PromptPayFieldType.checksum,
		
	};

	PromptPayFieldType type;
  String typeID;
	int length;
	String data;

	PromptPayField();

	PromptPayField.fromSubStringOfQRData(String fieldQRData) {
		type = determineFieldType(fieldQRData.substring(0, 2));
    typeID = fieldQRData.substring(0, 2);
		length = int.parse(fieldQRData.substring(2, 4));
		data = fieldQRData.substring(4, 4 + length);
	}

	PromptPayField.fromTransferringOrBillingSubType(String fieldQRData) {
		type = determineFieldType(fieldQRData.substring(0, 5));
    typeID = fieldQRData.substring(3, 5);
		length = int.parse(fieldQRData.substring(5, 7));
		data = fieldQRData.substring(7, 7 + length);
	}

	static PromptPayFieldType determineFieldType(String fieldData) {
		if (_mapIDNumberWithField[fieldData] == null) {
			return PromptPayFieldType.unknown;
		}

		return _mapIDNumberWithField[fieldData];
	}
}

class PromptPayData {
	PromptPayField emvcoVersion;
	PromptPayField qrType;
	PromptPayField transferring;
	PromptPayField transferringSubType;
	PromptPayField transferringPhoneNumber;
	PromptPayField transferringIdentityNumber;
	PromptPayField transferringEWallet;
	PromptPayField billing;
	PromptPayField billingType;
	PromptPayField billingID;
	PromptPayField billingReferenceNumber1;
	PromptPayField billingReferenceNumber2;
	PromptPayField country;
	PromptPayField currency;
	PromptPayField amount;
  PromptPayField unknownFieldTypeForBilling;
	PromptPayField checksum;

	PromptPayData.fromQRData(String qrData) {
		var currentIndex = 0;
		while (currentIndex < qrData.length) {
			var dataLength = int.parse(qrData.substring(currentIndex + 2, currentIndex + 4));
			var promptPayField = PromptPayField.fromSubStringOfQRData(qrData.substring(currentIndex, currentIndex + 2 + 2 + dataLength));

			switch(promptPayField.type) {
			  case PromptPayFieldType.unknown:
			    break;
			  case PromptPayFieldType.EMVCoVersion:
			    emvcoVersion = promptPayField;
			    break;
			  case PromptPayFieldType.qrType:
			    qrType = promptPayField;
			    break;
			  case PromptPayFieldType.transferring:
			    transferring = promptPayField;
			    break;
			  case PromptPayFieldType.billing:
			    billing = promptPayField;
			    break;
			  case PromptPayFieldType.country:
			    country = promptPayField;
			    break;
			  case PromptPayFieldType.currency:
			    currency = promptPayField;
			    break;
			  case PromptPayFieldType.amount:
			    amount = promptPayField;
			    break;
        case PromptPayFieldType.unknownFieldTypeForBilling:
          unknownFieldTypeForBilling = promptPayField;
          break;
			  case PromptPayFieldType.checksum:
			    checksum = promptPayField;
			    break;
			  default:
				break;		
			}

			currentIndex = currentIndex + 2 + 2 + dataLength;
		}

		// extract subtype
		if (transferring != null) {
			var trasferringCurrentIndex = 0;
			while (trasferringCurrentIndex < transferring.data.length) {
				var dataLength = int.parse(transferring.data.substring(trasferringCurrentIndex + 2, trasferringCurrentIndex + 4));
				var transferringPromptPayField = PromptPayField.fromTransferringOrBillingSubType("29_${transferring.data.substring(trasferringCurrentIndex, trasferringCurrentIndex + 2 + 2 + dataLength)}");

				switch (transferringPromptPayField.type) {
				  case PromptPayFieldType.transferringType:
				  	transferringSubType = transferringPromptPayField;
				    break;
				  case PromptPayFieldType.transferringPhoneNumber:
				    transferringPhoneNumber = transferringPromptPayField;
				    break;
				  case PromptPayFieldType.transferringIdentityNumber:
				    transferringIdentityNumber = transferringPromptPayField;
				    break;
				  case PromptPayFieldType.transferringEWallet:
				    transferringEWallet = transferringPromptPayField;
				    break;
				  default:
				    break;
				}

				trasferringCurrentIndex = trasferringCurrentIndex + 2 + 2 + dataLength;
			}
		}

		if (billing != null) {
			var billingCurrentIndex = 0;
			while (billingCurrentIndex < billing.data.length) {
				var dataLength = int.parse(billing.data.substring(billingCurrentIndex + 2, billingCurrentIndex + 4));
				var billingPromptPayField = PromptPayField.fromTransferringOrBillingSubType("30_${billing.data.substring(billingCurrentIndex, billingCurrentIndex + 2 + 2 + dataLength)}");

				switch (billingPromptPayField.type) {
				  case PromptPayFieldType.billingType:
				  	billingType = billingPromptPayField;
				    break;
				  case PromptPayFieldType.billingID:
				    billingID = billingPromptPayField;
				    break;
				  case PromptPayFieldType.billingReferenceNumber1:
				    billingReferenceNumber1 = billingPromptPayField;
				    break;
				  case PromptPayFieldType.billingReferenceNumber2:
				    billingReferenceNumber2 = billingPromptPayField;
				    break;
				  default:
				    break;
				}

				billingCurrentIndex = billingCurrentIndex + 2 + 2 + dataLength;
			}
		}
	}

  Iterable<PromptPayField> asIterable() {
    return [emvcoVersion, qrType, transferring, billing, country, currency, amount, unknownFieldTypeForBilling];
  }
}