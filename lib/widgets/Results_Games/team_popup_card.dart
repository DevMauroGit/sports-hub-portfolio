import 'package:flutter/material.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Results_Games/teammate_carousel.dart';

class TeamPopupCard1 extends StatefulWidget {
  const TeamPopupCard1({
    super.key,
    required this.appointment,
    required this.h,
    required this.w,
    required this.future,
    required this.allTeammateData,
    required this.allTeammate,
    required this.sport,
    required this.list1,
  });

  final Map appointment;

  final double h;
  final double w;
  final Future future;

  final List allTeammateData;
  final List allTeammate;

  final String sport;

  final List list1;

  @override
  State<TeamPopupCard1> createState() => TeamPopupCard1State();
}

class TeamPopupCard1State extends State<TeamPopupCard1> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: widget.h > 700 ? 120 : 60),
                width: widget.w * 0.8,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(
                  children: [
                    SizedBox(height: widget.h * 0.03),
                    Container(
                      width: widget.w * 0.6,
                      padding: EdgeInsets.symmetric(
                        vertical: widget.h * 0.015,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kBackgroundColor2,
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: widget.w > 385 ? 15 : 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        child: Center(
                          child: Text(
                            'Aggiungi i tuoi amici:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.w > 605
                                  ? 22
                                  : widget.w > 380
                                      ? 16
                                      : 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.h * 0.03),
                    TeammateCarousel1(
                      appointment: widget.appointment,
                      allTeammate: widget.allTeammateData,
                      sport: widget.sport,
                      list1: widget.list1,
                    ),
                    SizedBox(height: widget.h * 0.05),
                  ],
                ))));
  }
}

class TeamPopupCard2 extends StatefulWidget {
  const TeamPopupCard2({
    super.key,
    required this.appointment,
    required this.date,
    required this.h,
    required this.w,
    required this.future,
    required this.allTeammate,
    required this.allTeammateData,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final String date;

  final double h;
  final double w;
  final Future future;

  final List allTeammate;
  final List allTeammateData;

  final String sport;

  final List list1;

  @override
  State<TeamPopupCard2> createState() => TeamPopupCardState();
}

class TeamPopupCardState extends State<TeamPopupCard2> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: widget.h > 700 ? 120 : 60),
                width: widget.w * 0.8,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(
                  children: [
                    SizedBox(height: widget.h * 0.03),
                    Container(
                      width: widget.w * 0.6,
                      padding: EdgeInsets.symmetric(
                        vertical: widget.h * 0.015,
                      ),
                      //margin: EdgeInsets.only(top: h*0.02),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kBackgroundColor2,
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: widget.w > 385 ? 15 : 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        child: Center(
                          child: Text(
                            'Aggiungi i tuoi amici:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.w > 605
                                  ? 22
                                  : widget.w > 380
                                      ? 16
                                      : 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.h * 0.03),
                    TeammateCarousel2(
                      appointment: widget.appointment,
                      allTeammate: widget.allTeammateData,
                      sport: widget.sport,
                      list1: widget.list1,
                    ),
                    SizedBox(height: widget.h * 0.05),
                  ],
                ))));
  }
}

class TeamCreatePopupCard1 extends StatefulWidget {
  const TeamCreatePopupCard1({
    super.key,
    required this.appointment,
    required this.h,
    required this.w,
    required this.future,
    required this.allTeammateData,
    required this.allTeammate,
    required this.sport,
    required this.list1,
  });

  final Map appointment;

  final double h;
  final double w;
  final Future future;

  final List allTeammateData;
  final List allTeammate;

  final String sport;

  final List list1;

  @override
  State<TeamCreatePopupCard1> createState() => TeamCreatePopupCard1State();
}

class TeamCreatePopupCard1State extends State<TeamCreatePopupCard1> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: widget.h > 700 ? 120 : 60),
                width: widget.w * 0.8,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(
                  children: [
                    SizedBox(height: widget.h * 0.03),
                    Container(
                      width: widget.w * 0.6,
                      padding: EdgeInsets.symmetric(
                        vertical: widget.h * 0.015,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kBackgroundColor2,
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: widget.w > 385 ? 15 : 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        child: Center(
                          child: Text(
                            'Aggiungi i tuoi amici:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.w > 605
                                  ? 22
                                  : widget.w > 380
                                      ? 16
                                      : 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.h * 0.03),
                    TeammateCreateCarousel1(
                      appointment: widget.appointment,
                      allTeammate: widget.allTeammateData,
                      sport: widget.sport,
                      list1: widget.list1,
                    ),
                    SizedBox(height: widget.h * 0.05),
                  ],
                ))));
  }
}

class TeamCreatePopupCard2 extends StatefulWidget {
  const TeamCreatePopupCard2({
    super.key,
    required this.appointment,
    required this.date,
    required this.h,
    required this.w,
    required this.future,
    required this.allTeammate,
    required this.allTeammateData,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final String date;

  final double h;
  final double w;
  final Future future;

  final List allTeammate;
  final List allTeammateData;

  final String sport;

  final List list1;

  @override
  State<TeamCreatePopupCard2> createState() => TeamCreatePopupCardState();
}

class TeamCreatePopupCardState extends State<TeamCreatePopupCard2> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: widget.h > 700 ? 120 : 60),
                width: widget.w * 0.8,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(
                  children: [
                    SizedBox(height: widget.h * 0.03),
                    Container(
                      width: widget.w * 0.6,
                      padding: EdgeInsets.symmetric(
                        vertical: widget.h * 0.015,
                      ),
                      //margin: EdgeInsets.only(top: h*0.02),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kBackgroundColor2,
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: widget.w > 385 ? 15 : 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        child: Center(
                          child: Text(
                            'Aggiungi i tuoi amici:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.w > 605
                                  ? 22
                                  : widget.w > 380
                                      ? 16
                                      : 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.h * 0.03),
                    TeammateCreateCarousel2(
                      appointment: widget.appointment,
                      allTeammate: widget.allTeammateData,
                      sport: widget.sport,
                      list1: widget.list1,
                    ),
                    SizedBox(height: widget.h * 0.05),
                  ],
                ))));
  }
}

class TeamRequest extends StatefulWidget {
  const TeamRequest({
    super.key,
    required this.appointment,
    required this.h,
    required this.w,
    required this.list1,
  });

  final Map appointment;
  final double h;
  final double w;

  final List list1;

  @override
  State<TeamRequest> createState() => TeamRequestState();
}

class TeamRequestState extends State<TeamRequest> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: widget.h > 700 ? 120 : 60),
                width: widget.w * 0.8,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(
                  children: [
                    SizedBox(height: widget.h * 0.03),
                    Container(
                      width: widget.w * 0.6,
                      padding: EdgeInsets.symmetric(
                        vertical: widget.h * 0.015,
                      ),
                      //margin: EdgeInsets.only(top: h*0.02),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kBackgroundColor2,
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: widget.w > 385 ? 15 : 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        child: Center(
                          child: Text(
                            'Giocatori che si sono proposti:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.w > 605
                                  ? 22
                                  : widget.w > 380
                                      ? 16
                                      : 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.h * 0.03),
                    TeammateCandidatoCarousel(
                      appointment: widget.appointment,
                      list1: widget.list1,
                    ),
                    SizedBox(height: widget.h * 0.05),
                  ],
                ))));
  }
}

class TeamRequest2 extends StatefulWidget {
  const TeamRequest2({
    super.key,
    required this.appointment,
    required this.date,
    required this.h,
    required this.w,
    required this.future,
    required this.allTeammate,
    required this.allTeammateData,
    required this.sport,
    required this.list1,
  });

  final Map appointment;
  final String date;

  final double h;
  final double w;
  final Future future;

  final List allTeammate;
  final List allTeammateData;

  final String sport;

  final List list1;

  @override
  State<TeamRequest2> createState() => TeamRequest2State();
}

class TeamRequest2State extends State<TeamRequest2> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: widget.h > 700 ? 120 : 60),
                width: widget.w * 0.8,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(
                  children: [
                    SizedBox(height: widget.h * 0.03),
                    Container(
                      width: widget.w * 0.6,
                      padding: EdgeInsets.symmetric(
                        vertical: widget.h * 0.015,
                      ),
                      //margin: EdgeInsets.only(top: h*0.02),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: kBackgroundColor2,
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: widget.w > 385 ? 15 : 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        child: Center(
                          child: Text(
                            'Giocatori che si sono proposti:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.w > 605
                                  ? 22
                                  : widget.w > 380
                                      ? 16
                                      : 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.h * 0.03),
                    TeammateCarousel2(
                      appointment: widget.appointment,
                      allTeammate: widget.allTeammateData,
                      sport: widget.sport,
                      list1: widget.list1,
                    ),
                    SizedBox(height: widget.h * 0.05),
                  ],
                ))));
  }
}
