import 'package:http/http.dart' as http;

void main() async {
  var headers = {
    'Content-Type': 'application/json',
    'Origin': '127.0.0.1',
    'Authorization':
        'Bearer JMmrxX0IPQ7k3Dzbi5KmxzGR15s6ajLKJOz04n9HwxWi7Dw/KYjMi9o1KyJwm6b+pAD3ZIhg9lZ62ml5xJyIWncp1s+XflkxQCoPkHsVpmXaUbAE/lYZti23e3Q/X96DAREN5KGVg2PILUo7p5O4x0c8jEIYH3LMzUBcHzPeKHmEC5nkRFypor5tv0BHixX172iVJUR19bVLmD7i3avv+b4vB5RrncR8xgXenwfrFkcpxIMd6h15DPkRyR2COYYTKRwBhHfyDXY3RTlTuy88nHa8ChchOE4w2ynGE1699KgNaEgroLS4KvsW3GsId0TY85oje5LOfxQOs4Lh/8kmNev+7Lo+Api0WJdDuGRothMhUE9aupMt4NAsdJJchRWdNr1L+tHUpkHrPVai6rQ4lXzhlOdI1iV6QRmoTLnJaKlvAdCu79hI+Qbh/maJ/uNpcwJyAxKDSSCJgaj/0KFZjhq6CTX5Qxn3piy294+Oi41kVBAlbwEylAwQNzbv2qfv0hOp/oByOI+JByGHA60qU5AtxdRREFQ8W7iEnRpsYep0HlUyuUDhmJt8SnzFf1e7ynlyrGoqAT4pQ/kvzjjy6R0F3wlBxEhG3Ix4EUxeinUlhCl2ifUJ3SwyiOnsuJaf8iyAWTQOmnDLBlJu2+UPSDMp3qJnSJhaTvYYU/XTOV4='
  };
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://openapi.m-pesa.com/sandbox/ipg/v2/vodacomTZN/getSession/'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}
