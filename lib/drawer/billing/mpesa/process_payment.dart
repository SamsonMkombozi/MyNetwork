import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  var headers = {
    'Content-Type': 'application/json',
    'Origin': '*',
    'Authorization':
        'Bearer VkhBZT5FfnR0Yjqc/9iUpZ4D8Vj0W6doYviUhkeAePpjZaf6OrmOxciZQKjBn8a3VmRzwmNd6i2bIbG4yhmHRs70EF2xuqSFOFr/Yh6BGkv7UcyXeMtLcLFXHjb6xFaQxBKtX/lt1EdHlc5q+VN08Hdlj4mreASiFd2sy7EmrxM947P/oWzJor5Az/I/fQwi3j784wKAp7w+I1BwbDFYLDO6TWmaVSbc07I39mSMu4rV1n1CdU7F0gcZ8wsYJm8NL81EBQsGdv+LBaiyvHI0dy3arK6YhSggtd3sUkiYEKKleqsNk3afE/C2/wz3ElDIDZ7TkUnvRjUUfaqYdukuwreJ6dzL+VijgCoGZkIsq4p96Dqg9ZLJeKq42LXuvjNmpjUBgeSN+V3LwJJ+ur7Hoa+kRAnbd48+dtXSaLd7eymP2Q9NJC6m9ImZrmst3jKXTWXbjoWVhwfhbeNnYmgsQ9LwHnN/9/6N95vUSYhuCA0KgmqyLU16wZNlC3W72qeBZD4vAyKN1pfCen/ntQEJbdMpgJhK+hUNKHp+Bba7A3lWaV8b0AhVGZygRuHKROtlvJ/TgY776q/fXS2sWXWAxyCiQb52wTnGum4sqpsyiVj8xnc/P0uK41h61I8qj66JigB4OjPfBtkfJTQ6PY3XRZ1EAAmPu35+qgvJjHFxvmY='
  };
  var request = http.Request(
      'POST',
      Uri.parse(
          'https://openapi.m-pesa.com/sandbox/ipg/v2/vodacomTZN/c2bPayment/singleStage/'));
  request.body = json.encode({
    "input_Amount": "10",
    "input_Country": "TZN",
    "input_Currency": "TZS",
    "input_CustomerMSISDN": "255767205251",
    "input_ServiceProviderCode": "000000",
    "input_ThirdPartyConversationID": "asv02e5958774f7ba228d83d0d689761",
    "input_TransactionReference": "T1234C",
    "input_PurchasedItemsDesc": "Shoes"
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}
