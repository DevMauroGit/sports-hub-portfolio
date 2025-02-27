import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_hub_ios/page/edit_phone_page.dart';
import 'package:sports_hub_ios/page/searching_page_2.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class TextandSave extends StatefulWidget {
  const TextandSave({
    super.key,
    required this.h,
    required this.w,
    required this.city,
    required this.ospite,
  });

  final double h;
  final double w;
  final String city;
  final bool ospite;

  @override
  State<TextandSave> createState() => _TextandSaveState();
}

class _TextandSaveState extends State<TextandSave> {
  var cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.h * 0.20,
        width: widget.w * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cerca i Clubs della tua Città o Provincia',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            SizedBox(height: widget.h * 0.01),
            TextFormField(
              inputFormatters: <TextInputFormatter>[UpperCaseTextFormatter()],
              controller: cityController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: widget.city,
                  prefixIcon: const Icon(Icons.person, color: kPrimaryColor),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0)),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                textStyle: const TextStyle(fontSize: 15),
                shape: const StadiumBorder(),
              ),
              onPressed: () async {
                String city = cityController.text.trim();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => SearchingPage2(
                              city: city,
                              ospite: widget.ospite,
                            ))));
              },
              child: const Text(
                "Cerca",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ));
  }
}
