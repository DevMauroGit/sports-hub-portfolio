import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/utils/datetime_converter.dart';

class PitchColumn extends StatefulWidget {
  final DateTime daySelected; // Selected day to display pitches for
  final int pitches_number; // Number of pitches to show

  const PitchColumn(
      {super.key, required this.daySelected, required this.pitches_number});

  @override
  State<PitchColumn> createState() => _PitchColumnState();
}

class _PitchColumnState extends State<PitchColumn> {
  @override
  Widget build(BuildContext context) {
    // Get the device screen height and width to make layout responsive
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    // Prepare a prefix for month formatting if month < 10 (for leading zero)
    String data = "";
    if (widget.daySelected.month < 10) {
      setState(() {
        data = "0";
      });
    }
    // Format month as MM_MonthName (e.g., 03_March)
    final getMonth =
        "$data${widget.daySelected.month}_${DateConverted.getMonth(widget.daySelected.month)}";

    // Define text style for pitch titles
    TextStyle titles = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: w > 380 ? 15 : 12);

    return Column(
      children: [
        SizedBox(height: h * 0.055), // Add vertical spacing at the top
        Container(
          // Container for the list of pitches
          height: h * 0.07 * widget.pitches_number,
          width: w * 0.25,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.pitches_number,
            itemBuilder: (context, index) => Container(
              // Each pitch container with styling and margin
              height: h * 0.065,
              width: w * 0.085,
              margin: EdgeInsets.only(bottom: h * 0.005),
              padding: EdgeInsets.symmetric(
                  vertical: h * 0.01, horizontal: h * 0.01),
              decoration: BoxDecoration(
                color: kBackgroundColor2,
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              // Display pitch number with the defined style
              child: Text(
                'Campo ${index + 1}',
                style: titles,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
