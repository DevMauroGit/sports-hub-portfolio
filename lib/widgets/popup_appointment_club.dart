import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/page/searching_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/Payment/payment_config.dart'
    as payment_configurations;
import 'package:pay/pay.dart';
import 'package:sports_hub_ios/widgets/pitch_table_appointment.dart';

class PopUpAppointmentClub extends StatefulWidget {
  const PopUpAppointmentClub({
    super.key,
    required this.h,
    required this.w,
    required this.hour,
    required this.sport,
    required this.email,
    required this.date,
  });

  final double h;
  final double w;

  final String hour;
  final String date;

  final String sport;
  final String email;

  @override
  State<PopUpAppointmentClub> createState() => PopUpAppointmentClubState();
}

class PopUpAppointmentClubState extends State<PopUpAppointmentClub> {
  var googlePayButton = GooglePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(
        payment_configurations.defaultGooglePay),
    paymentItems: [
      PaymentItem(
        label: 'Total',
        amount: '$price.00',
        status: PaymentItemStatus.final_price,
      )
    ],
    width: double.infinity,
    type: GooglePayButtonType.pay,
    margin: const EdgeInsets.only(top: 15.0),
    onPaymentResult: (result) {
      debugPrint('Payment Result $result');
    },
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                height: widget.h > 700 ? widget.h * 0.75 : widget.h * 0.85,
                width: widget.w * 0.85,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(children: [
                  SizedBox(height: widget.h * 0.05),
                  Container(
                    height: widget.h > 700 ? widget.h * 0.65 : widget.h * 0.75,
                    width: widget.w * 0.75,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: kBackgroundColor2,
                    ),
                    child: Column(
                      children: [
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 30
                                  : widget.w > 385
                                      ? 20
                                      : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          child: Text(
                            'DATA:',
                            style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 30
                                  : widget.w > 385
                                      ? 20
                                      : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: widget.h * 0.01),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 30
                                  : widget.w > 385
                                      ? 20
                                      : 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          child: Text(
                            widget.date,
                            style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 30
                                  : widget.w > 385
                                      ? 20
                                      : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: widget.h * 0.01),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 30
                                  : widget.w > 385
                                      ? 20
                                      : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          child: Text(
                            'ORARIO:',
                            style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 30
                                  : widget.w > 385
                                      ? 20
                                      : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: widget.h * 0.01),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 30
                                  : widget.w > 385
                                      ? 20
                                      : 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          child: Text(
                            widget.hour,
                            style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 30
                                  : widget.w > 385
                                      ? 20
                                      : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: widget.w > 385 ? 4 : 7,
                          child: Lottie.asset('assets/Gif/success.json'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: DefaultTextStyle(
                            style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 30
                                    : widget.w > 385
                                        ? 20
                                        : 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                            child: Text(
                              'Prenotazione Completata',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 30
                                    : widget.w > 385
                                        ? 20
                                        : 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 30
                                  : widget.w > 385
                                      ? 20
                                      : 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          child: Text(
                            'Controlla e gestisci le prenotazione dal tuo Profilo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 30
                                    : widget.w > 385
                                        ? 20
                                        : 14,
                                color: Colors.white),
                          ),
                        ),
                        //googlePayButton,
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 13),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              textStyle: const TextStyle(fontSize: 20),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () => Get.to(
                                () => ProfilePage(
                                    docIds: widget.email,
                                    avviso: false,
                                    sport: widget.sport),
                                transition: Transition.fadeIn),
                            child: Text(
                              widget.w > 385
                                  ? "Vai al Profilo"
                                  : "Vai al Profilo",
                              style: TextStyle(
                                color: kBackgroundColor2,
                                fontSize: widget.w > 605
                                    ? 30
                                    : widget.w > 385
                                        ? 20
                                        : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]))));
  }
}

class PopUpAppointmentCreateClub extends StatefulWidget {
  const PopUpAppointmentCreateClub({
    super.key,
    required this.h,
    required this.w,
    required this.hour,
    required this.sport,
    required this.email,
    required this.date,
  });

  final double h;
  final double w;

  final String hour;
  final String date;

  final String sport;
  final String email;

  @override
  State<PopUpAppointmentCreateClub> createState() =>
      PopUpAppointmentCreateClubState();
}

class PopUpAppointmentCreateClubState
    extends State<PopUpAppointmentCreateClub> {
  var googlePayButton = GooglePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(
        payment_configurations.defaultGooglePay),
    paymentItems: [
      PaymentItem(
        label: 'Total',
        amount: '$price.00',
        status: PaymentItemStatus.final_price,
      )
    ],
    width: double.infinity,
    type: GooglePayButtonType.pay,
    margin: const EdgeInsets.only(top: 15.0),
    onPaymentResult: (result) {
      debugPrint('Payment Result $result');
    },
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                height: widget.h > 700 ? widget.h * 0.75 : widget.h * 0.85,
                width: widget.w * 0.85,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(children: [
                  SizedBox(height: widget.h * 0.05),
                  Container(
                    height: widget.h > 700 ? widget.h * 0.65 : widget.h * 0.75,
                    width: widget.w * 0.75,
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 5),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: kBackgroundColor2,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                DefaultTextStyle(
                                  style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 30
                                          : widget.w > 385
                                              ? 20
                                              : 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  child: Text(
                                    'DATA:',
                                    style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 30
                                          : widget.w > 385
                                              ? 20
                                              : 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: widget.h * 0.01),
                                DefaultTextStyle(
                                  style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 30
                                          : widget.w > 385
                                              ? 20
                                              : 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                  child: Text(
                                    widget.date,
                                    style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 30
                                          : widget.w > 385
                                              ? 20
                                              : 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                DefaultTextStyle(
                                  style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 30
                                          : widget.w > 385
                                              ? 20
                                              : 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  child: Text(
                                    'ORARIO:',
                                    style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 30
                                          : widget.w > 385
                                              ? 20
                                              : 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: widget.h * 0.01),
                                DefaultTextStyle(
                                  style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 30
                                          : widget.w > 385
                                              ? 20
                                              : 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                  child: Text(
                                    widget.hour,
                                    style: TextStyle(
                                      fontSize: widget.w > 605
                                          ? 30
                                          : widget.w > 385
                                              ? 20
                                              : 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),

                        Expanded(
                          flex: widget.w > 385 ? 4 : 7,
                          child: Lottie.asset('assets/Gif/success.json'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: DefaultTextStyle(
                            style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 30
                                    : widget.w > 385
                                        ? 20
                                        : 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                            child: Text(
                              'Partita creata\nRicorda di prenotare il campo!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 30
                                    : widget.w > 385
                                        ? 20
                                        : 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 30
                                  : widget.w > 385
                                      ? 20
                                      : 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          child: Text(
                            'Controlla e gestisci le partite dal tuo Profilo\n\nOrganizzati con altri giocatori dalla pagina ricerca',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 30
                                    : widget.w > 385
                                        ? 20
                                        : 13,
                                color: Colors.white),
                          ),
                        ),
                        //googlePayButton,
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 13),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              textStyle: const TextStyle(fontSize: 20),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () => Get.to(
                                () => ProfilePage(
                                    docIds: widget.email,
                                    avviso: false,
                                    sport: widget.sport),
                                transition: Transition.fadeIn),
                            child: Text(
                              widget.w > 385
                                  ? "Vai al Profilo"
                                  : "Vai al Profilo",
                              style: TextStyle(
                                color: kBackgroundColor2,
                                fontSize: widget.w > 605
                                    ? 30
                                    : widget.w > 385
                                        ? 20
                                        : 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]))));
  }
}

class PopUpDescription extends StatefulWidget {
  const PopUpDescription({
    super.key,
    required this.h,
    required this.w,
    required this.appointment,
  });

  final double h;
  final double w;
  final Map appointment;

  @override
  State<PopUpDescription> createState() => PopUpDescriptionState();
}

class PopUpDescriptionState extends State<PopUpDescription> {
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
            child: Container(
                height: widget.h > 700 ? widget.h * 0.75 : widget.h * 0.85,
                width: widget.w * 0.85,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: kPrimaryColor.withOpacity(0.7),
                ),
                child: Column(children: [
                  SizedBox(height: widget.h * 0.05),
                  Container(
                    height: widget.h > 700 ? widget.h * 0.65 : widget.h * 0.75,
                    width: widget.w * 0.75,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: kBackgroundColor2,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.w * 0.05,
                            //vertical: h * 0.01
                          ),
                          child: TextFormField(
                            controller: descriptionController,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: widget.w > 385 ? 16 : 13),
                            decoration: InputDecoration(
                                hintText:
                                    "Aggiungi una descrizione o dei dettagli per organizzarsi",
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            minLines: 2,
                            maxLines: 8,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: kDefaultPadding, bottom: 20),
                          child: Text(
                            '                                                   max 8 righe',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: widget.w > 385 ? 14 : 12),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedButton(
                            isFixedHeight: false,
                            height: widget.h * 0.05,
                            width: widget.w * 0.4,
                            text: "CONFERMA",
                            buttonTextStyle: TextStyle(
                                letterSpacing: 0.5,
                                color: Colors.black,
                                fontSize: widget.w > 605 ? 22 : 16,
                                fontWeight: FontWeight.bold),
                            color: kPrimaryColor,
                            pressEvent: () async {
                              String description =
                                  descriptionController.text.trim();

                              FirebaseDatabase.instanceFor(
                                      app: Firebase.app(),
                                      databaseURL: dbCreaMatchURL)
                                  .ref()
                                  .child('Prenotazioni')
                                  .child('Crea_Match')
                                  .child(widget.appointment['city'])
                                  .child(widget.appointment['sport'])
                                  .child(widget.appointment['dateURL'])
                                  .update({'description': description});

                              Get.to(
                                  () => SearchingPage(
                                        city: widget.appointment['city'],
                                        h: widget.h,
                                        w: widget.w,
                                        ospite: false,
                                      ),
                                  transition: Transition.fadeIn);
                            }),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                ]))));
  }
}
