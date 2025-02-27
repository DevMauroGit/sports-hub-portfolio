import 'package:flutter/material.dart';

class FootballStatsWidget extends StatelessWidget {
  const FootballStatsWidget(
      {super.key, required this.profile, required this.visit});

  final Map profile;
  final bool visit;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(text: 'Games', value: profile['games'], w: w),
        buildDivider(w),
        buildButton(text: '  Goal   ', value: profile['goals'], w: w),
        buildDivider(w),
        buildButton(text: 'Win', value: profile['win'], w: w),
      ],
    );
  }

  Widget buildDivider(double w) => SizedBox(
        height: w > 605 ? 50 : 24,
        child: VerticalDivider(
          color: visit == false ? Colors.black : Colors.white,
        ),
      );

  Widget buildButton(
          {required String text, required int value, required double w}) =>
      MaterialButton(
        padding:
            EdgeInsets.symmetric(vertical: 4, horizontal: w > 605 ? 20 : 0),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$value',
              style: TextStyle(
                  color: visit == false ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: w > 605
                      ? 25
                      : w > 385
                          ? 16
                          : 13),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                  color: visit == false ? Colors.black : Colors.white,
                  fontSize: w > 605
                      ? 25
                      : w > 385
                          ? 16
                          : 13),
            )
          ],
        ),
      );
}

class TennisStatsWidget extends StatelessWidget {
  const TennisStatsWidget(
      {super.key, required this.profile, required this.visit});

  final Map profile;
  final bool visit;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(text: 'Games', value: profile['games_tennis'], w: w),
        buildDivider(w),
        buildButton(text: 'Set Vinti', value: profile['set_vinti'], w: w),
        buildDivider(w),
        buildButton(text: 'Win', value: profile['win_tennis'], w: w),
      ],
    );
  }

  Widget buildDivider(double w) => SizedBox(
        height: w > 605 ? 60 : 24,
        child: VerticalDivider(
          color: visit == false ? Colors.black : Colors.white,
        ),
      );

  Widget buildButton(
          {required String text, required int value, required double w}) =>
      MaterialButton(
        padding:
            EdgeInsets.symmetric(vertical: 4, horizontal: w > 605 ? 20 : 0),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$value',
              style: TextStyle(
                  color: visit == false ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: w > 605
                      ? 25
                      : w > 385
                          ? 16
                          : 13),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                  color: visit == false ? Colors.black : Colors.white,
                  fontSize: w > 605
                      ? 25
                      : w > 385
                          ? 16
                          : 13),
            )
          ],
        ),
      );
}
