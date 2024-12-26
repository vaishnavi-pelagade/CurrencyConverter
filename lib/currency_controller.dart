import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyController extends GetxController {
  var currencies = <String, String>{}.obs;
  var fromCurrency = ''.obs;
  var toCurrency = ''.obs;
  var conversionRate = 0.0.obs;
  var amount = 0.0.obs;
  var result = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrencies();
  }


  void fetchCurrencies() async {
    const url =
        'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json';
    const fallbackUrl =
        'https://latest.currency-api.pages.dev/v1/currencies.json';

    try {
      final response = await http.get(Uri.parse(url));
      print('Main API Response: ${response.body}'); 
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Decoded main API data: $data'); 
        currencies.value = Map<String, String>.from(data);
        if (currencies.isNotEmpty) {
          fromCurrency.value = currencies.keys.first;
          toCurrency.value = currencies.keys.first;
        }
      } else {
        _fetchFromFallback(fallbackUrl);
      }
    } catch (e) {
      print('Error fetching currencies: $e');
      _fetchFromFallback(fallbackUrl);
    } finally {
      isLoading.value = false;
    }
  }

  
  void _fetchFromFallback(String fallbackUrl) async {
    try {
      final response = await http.get(Uri.parse(fallbackUrl));
      print(
          'Fallback API Response: ${response.body}'); 
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
            'Decoded fallback data: $data'); 
        currencies.value = Map<String, String>.from(data);
        if (currencies.isNotEmpty) {
          fromCurrency.value = currencies.keys.first;
          toCurrency.value = currencies.keys.first;
        }
      } else {
        Get.snackbar('Error', 'Failed to load currencies');
      }
    } catch (e) {
      print('Error fetching currencies from fallback: $e'); 
      Get.snackbar('Error', 'Unable to fetch currencies: $e');
    }
  }


  void convertCurrency() async {
    if (fromCurrency.value.isEmpty ||
        toCurrency.value.isEmpty ||
        amount.value <= 0) {
      Get.snackbar('Invalid Input', 'Please fill all fields correctly');
      return;
    }

    final url =
        'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/${fromCurrency.value}/${toCurrency.value}.json';
    const fallbackUrl = 'https://latest.currency-api.pages.dev/v1/currencies/';

    try {
      final response = await http.get(Uri.parse(url));
      print(
          'Main API Conversion Response: ${response.body}'); 

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
            'Decoded conversion data: $data'); 

     
        if (data['rates'] != null && data['rates'][toCurrency.value] != null) {
          conversionRate.value = data['rates'][toCurrency.value];
          result.value =
              (conversionRate.value * amount.value).toStringAsFixed(2);
        } else {
          Get.snackbar('Error', 'Conversion rate not available in main API');
        }
      } else {
        _convertFromFallback(fallbackUrl);
      }
    } catch (e) {
      print('Error during conversion: $e'); 
      _convertFromFallback(fallbackUrl);
    }
  }

  void _convertFromFallback(String fallbackUrl) async {
    final url = '$fallbackUrl${fromCurrency.value}.json';
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      print(
          'Fallback API Conversion Response: ${response.body}'); 

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
            'Decoded fallback conversion data: $data'); 
        print(toCurrency.value);
        print(data[toCurrency.value]);
        print(data[fromCurrency.value][toCurrency.value]);
      
        if (data[fromCurrency.value] != null) {
          conversionRate.value = data[fromCurrency.value][toCurrency.value];
          result.value =
              (conversionRate.value * amount.value).toStringAsFixed(2);
        } else {
          Get.snackbar('Error', 'Failed to convert currency in fallback');
        }
      } else {
        Get.snackbar('Error', 'Failed to convert currency in fallback');
      }
    } catch (e) {
      print('Fallback Error: $e');
      Get.snackbar('Error', 'Conversion failed in fallback: $e');
    }
  }
}
