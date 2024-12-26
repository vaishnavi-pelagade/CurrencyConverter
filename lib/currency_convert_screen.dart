import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kerela/currency_controller.dart';

class CurrencyConverterPage extends StatelessWidget {
  final CurrencyController controller = Get.put(CurrencyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Currency Converter',
          style: GoogleFonts.notoSansArabic(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          margin: EdgeInsets.only(left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'From Currency',
                style: GoogleFonts.notoSansArabic(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              DropdownButton<String>(
                value: controller.fromCurrency.value.isEmpty
                    ? null
                    : controller.fromCurrency.value,
                items: controller.currencies.entries
                    .map((entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text('${entry.key} - ${entry.value}'),
                        ))
                    .toList(),
                onChanged: controller.currencies.isNotEmpty
                    ? (value) {
                        controller.fromCurrency.value = value!;
                      }
                    : null,
                hint: Text(
                  'From Currency',
                  style: GoogleFonts.notoSansArabic(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                isExpanded: true,
              ),
              Icon(Icons.swap_vert_circle, size: 60, color: Colors.blue), //

              Text(
                'To Currency',
                style: GoogleFonts.notoSansArabic(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              DropdownButton<String>(
                value: controller.toCurrency.value.isEmpty
                    ? null
                    : controller.toCurrency.value,
                items: controller.currencies.entries
                    .map((entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text('${entry.key} - ${entry.value}'),
                        ))
                    .toList(),
                onChanged: controller.currencies.isNotEmpty
                    ? (value) {
                        controller.toCurrency.value = value!;
                      }
                    : null,
                hint: Text(
                  'To Currency',
                  style: GoogleFonts.notoSansArabic(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                isExpanded: true,
              ),
              SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: GoogleFonts.notoSansArabic(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  controller.amount.value = double.tryParse(value) ?? 0.0;
                },
              ),
              SizedBox(height: 80),
              SizedBox(
                height: 60, // Set your desired height here
                child: ElevatedButton(
                  onPressed: controller.convertCurrency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Set the button color to blue
                  ),
                  child: Text(
                    'Convert',
                    style: GoogleFonts.notoSansArabic(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: Colors.white, // Set the text color to white
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Obx(() => Text(
                    controller.result.value.isEmpty
                        ? 'Result will appear here'
                        : 'Result: ${controller.result.value}',
                    style: GoogleFonts.notoSansArabic(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ],
          ),
        );
      }),
    );
  }
}
