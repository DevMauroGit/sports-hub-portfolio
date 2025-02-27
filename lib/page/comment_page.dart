import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:safe_text/safe_text.dart';
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/page/searching_page.dart';
import 'package:sports_hub_ios/screen/searching_screen.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class CommentPage extends StatefulWidget {
  const CommentPage(
      {super.key,
      required this.h,
      required this.w,
      required this.appointment,
      required this.list1});

  final double h;
  final double w;

  final Map appointment;

  final List list1;

  @override
  State<CommentPage> createState() => _CommentPageState();
}

final formKey = GlobalKey<FormState>();

class _CommentPageState extends State<CommentPage> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  CollectionReference user = FirebaseFirestore.instance.collection('User');
  final String utente = FirebaseAuth.instance.currentUser!.email.toString();
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  UserController userController = Get.put(UserController());

  var chatController = TextEditingController();
  var descriptionController = TextEditingController();

  Map appointmentData = {};

  String _textInput = ''; // Variable to store user input text

  // Method to filter out bad words from the user input
  void _filterText() {
    setState(() {
      // Call the filterText method from the SafeText class
      _textInput = SafeText.filterText(
        text: _textInput, // Pass the user input text
        extraWords: [
          'cazzo',
          'figa',
          'minchia',
          'vaffanculo' 'puttana',
          'troia',
          'zoccola',
          'bocchinara',
          'prostituta',
          'culo',
          'merda',
          'nero',
          'negro',
          'nigga',
          'gay',
          'frocio',
          'ricchione',
          'culattone',
          'porno',
          'uccido',
          'ammazzo',
          'stupro',
          'droga',
          'vagina',
          'stronzo',
          'bastardo',
          'muori',
          'ammazzati',
          'pompa',
          'sega',
          'anale',
          'anal',
          'fuck',
          'shit',
          'cock',
          'dick',
          'pussy'
        ], // Additional bad words to filter
        excludedWords: [], // Words to be excluded from filtering
        useDefaultWords: true, // Whether to use the default list of bad words
        fullMode:
            true, // Whether to fully filter out the bad word or only obscure the middle part
        obscureSymbol: '*', // Symbol used to obscure the bad word
      );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textInput = widget.appointment['description'];
    _filterText();

    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Scaffold(
            //resizeToAvoidBottomInset: false,
            appBar: TopBar(),
            bottomNavigationBar: BottomBar(
              context,
            ),
            body: Stack(children: [
              SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      //height: h*0.8,
                      width: widget.w * 0.95,
                      child: Column(children: [
                        Center(
                            child: Container(
                          height: widget.h > 800
                              ? widget.h * 0.30
                              : widget.h * 0.35,
                          width: widget.w * 0.9,
                          padding: const EdgeInsets.only(
                              top: kDefaultPadding,
                              bottom: kDefaultPadding / 2),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: kBackgroundColor2,
                          ),
                          child: utente == widget.appointment['email']
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: widget.w * 0.05,
                                        //vertical: h * 0.01
                                      ),
                                      child: TextFormField(
                                        controller: descriptionController,
                                        keyboardType: TextInputType.multiline,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.w > 385 ? 16 : 13),
                                        decoration: InputDecoration(
                                            hintText: widget
                                                    .appointment['description']
                                                    .toString()
                                                    .isEmpty
                                                ? 'Aggiungi una descrizione o dei dettagli per organizzarsi'
                                                : widget
                                                    .appointment['description'],
                                            hintStyle: TextStyle(
                                              fontSize:
                                                  widget.w > 385 ? 16 : 11,
                                              color: Colors.white,
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0)),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        minLines: 2,
                                        maxLines: 3,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: kDefaultPadding, bottom: 20),
                                      child: Text(
                                        '                                                   max 6 righe',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.w > 385 ? 14 : 10),
                                      ),
                                    ),
                                    Spacer(),
                                    AnimatedButton(
                                        isFixedHeight: false,
                                        height: widget.h * 0.05,
                                        width: widget.w * 0.4,
                                        text: "CONFERMA",
                                        buttonTextStyle: TextStyle(
                                            letterSpacing: 0.5,
                                            color: Colors.black,
                                            fontSize: widget.w > 605 ? 22 : 14,
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
                                              .child(
                                                  widget.appointment['sport'])
                                              .child(
                                                  widget.appointment['dateURL'])
                                              .update(
                                                  {'description': description});

                                          Get.to(
                                              () => SearchingPage(
                                                    city: widget
                                                        .appointment['city'],
                                                    h: widget.h,
                                                    w: widget.w,
                                                    ospite: false,
                                                  ),
                                              transition: Transition.fadeIn);
                                        }),
                                    const SizedBox(height: 20),
                                  ],
                                )
                              : Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    widget.appointment['description'].length !=
                                            0
                                        ? _textInput
                                        : 'Nessuna descrizione fornita',
                                    style: TextStyle(
                                        fontSize: widget.w > 605
                                            ? 22
                                            : widget.w > 385
                                                ? 18
                                                : 12,
                                        color: Colors.white),
                                  ),
                                ),
                        )),
                        Center(
                            child: Column(children: [
                          if (widget.appointment['commentiTot'] != 0)
                            Container(
                                height: widget.appointment['commentiTot'] == 1
                                    ? widget.h * 0.15
                                    : widget.appointment['commentiTot'] == 2
                                        ? widget.h * 0.1 * 2
                                        : widget.appointment['commentiTot'] == 3
                                            ? widget.h * 0.08 * (3)
                                            : widget.h * 0.08 * (4),
                                width: widget.w * 0.9,
                                margin: const EdgeInsets.only(
                                    bottom: kDefaultPadding,
                                    top: kDefaultPadding),
                                padding: const EdgeInsets.symmetric(
                                    vertical: kDefaultPadding / 1.5,
                                    horizontal: kDefaultPadding),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: kBackgroundColor2,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                        //padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                                        height:
                                            widget.appointment['commentiTot'] <=
                                                    3
                                                ? widget.h *
                                                    0.05 *
                                                    widget.appointment[
                                                        'commentiTot']
                                                : widget.h * 0.05 * 4,
                                        child: FirebaseAnimatedList(
                                            query: FirebaseDatabase.instanceFor(
                                                    app: Firebase.app(),
                                                    databaseURL: dbCreaMatchURL)
                                                .ref()
                                                .child('Prenotazioni')
                                                .child('Crea_Match')
                                                .child(
                                                    widget.appointment['city'])
                                                .child('football')
                                                .child(widget
                                                    .appointment['dateURL'])
                                                .child('commenti'),
                                            itemBuilder: (BuildContext context,
                                                DataSnapshot snapshot,
                                                Animation<double> animation,
                                                int index) {
                                              var commenti = snapshot.value;
                                              String chat = commenti.toString();
                                              String chatFiltered =
                                                  SafeText.filterText(
                                                text:
                                                    chat, // Pass the user input text
                                                extraWords: [
                                                  'cazzo',
                                                  'figa',
                                                  'minchia',
                                                  'vaffanculo' 'puttana',
                                                  'troia',
                                                  'zoccola',
                                                  'bocchinara',
                                                  'prostituta',
                                                  'culo',
                                                  'merda',
                                                  'nero',
                                                  'negro',
                                                  'nigga',
                                                  'gay',
                                                  'frocio',
                                                  'ricchione',
                                                  'culattone',
                                                  'porno',
                                                  'uccido',
                                                  'ammazzo',
                                                  'stupro',
                                                  'cocaina',
                                                  'erba',
                                                  'fumo',
                                                  'droga',
                                                  'vagina',
                                                  'stronzo',
                                                  'bastardo',
                                                  'muori',
                                                  'ammazzati',
                                                  'pompa',
                                                  'sega',
                                                  'anale',
                                                  'anal',
                                                  'fuck',
                                                  'shit',
                                                  'cock',
                                                  'dick',
                                                  'pussy'
                                                ], // Additional bad words to filter
                                                excludedWords: [], // Words to be excluded from filtering
                                                useDefaultWords:
                                                    true, // Whether to use the default list of bad words
                                                fullMode:
                                                    true, // Whether to fully filter out the bad word or only obscure the middle part
                                                obscureSymbol:
                                                    '*', // Symbol used to obscure the bad word
                                              );

                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: widget.h * 0.01),
                                                child: RichText(
                                                    text: TextSpan(
                                                        text:
                                                            '${widget.appointment['c${index}_name']} :  ',
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 93, 165, 99),
                                                          fontSize: 18,
                                                        ),
                                                        children: [
                                                      TextSpan(
                                                          text: chatFiltered,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: widget.w >
                                                                    605
                                                                ? 20
                                                                : widget.w > 385
                                                                    ? 16
                                                                    : 14,
                                                          ))
                                                    ])),
                                              );
                                            })),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: widget.h * 0.05,
                                          width: widget.w * 0.60,
                                          decoration: BoxDecoration(
                                              color: kBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 10,
                                                    spreadRadius: 7,
                                                    offset: const Offset(1, 1),
                                                    color: Colors.grey
                                                        .withOpacity(0.2))
                                              ]),
                                          child: TextFormField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  30),
                                            ],
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: chatController,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    widget.w > 385 ? 13 : 10),
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Scrivi un messaggio breve",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30))),
                                          ),
                                        ),
                                        FutureBuilder<DocumentSnapshot>(
                                            future: user.doc(utente).get(),
                                            builder: (((context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                Map<String, dynamic> profile =
                                                    snapshot.data!.data()
                                                        as Map<String, dynamic>;
                                                return GestureDetector(
                                                  child: Text(
                                                    " Invia  ",
                                                    style: TextStyle(
                                                        fontSize: widget.w > 605
                                                            ? 25
                                                            : widget.w > 390
                                                                ? 18
                                                                : 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  onTap: () async {
                                                    String commento =
                                                        chatController.text
                                                            .trim();

                                                    if (commento.isNotEmpty) {
                                                      print('go go go');

                                                      //              await FirebaseDatabase.instanceFor(
                                                      //                    app: Firebase.app(),
                                                      //                  databaseURL: dbPrenotazioniURL)
                                                      //            .ref()
                                                      //          .child('Prenotazioni')
                                                      //        .child(widget.appointment['id'])
                                                      //      .child('football')
                                                      //    .child('Crea_Match')
                                                      //                    .child(widget.appointment['dateURL'])
                                                      //                  .child('commenti')
                                                      //                .update({
                                                      //            'c${widget.appointment['commentiTot']}':
                                                      //              commento
                                                      //      });

                                                      //                      await FirebaseDatabase.instanceFor(
                                                      //                            app: Firebase.app(),
                                                      //                          databaseURL: dbPrenotazioniURL)
                                                      //                    .ref()
                                                      //                  .child('Prenotazioni')
                                                      //                .child(widget.appointment['id'])
                                                      //              .child('football')
                                                      //            .child('Crea_Match')
                                                      //          .child(widget.appointment['dateURL'])
                                                      //        .update({
                                                      //    'c${widget.appointment['commentiTot']}_name':
                                                      //      profile['username'],
                                                      //                          'commentiTot':
                                                      //                            widget.appointment['commentiTot'] + 1,
                                                      //                    });

                                                      await FirebaseDatabase
                                                              .instanceFor(
                                                                  app: Firebase
                                                                      .app(),
                                                                  databaseURL:
                                                                      dbCreaMatchURL)
                                                          .ref()
                                                          .child('Prenotazioni')
                                                          .child('Crea_Match')
                                                          .child(widget
                                                                  .appointment[
                                                              'city'])
                                                          .child('football')
                                                          .child(widget
                                                                  .appointment[
                                                              'dateURL'])
                                                          .child('commenti')
                                                          .update({
                                                        'c${widget.appointment['commentiTot']}':
                                                            commento
                                                      });

                                                      await FirebaseDatabase
                                                              .instanceFor(
                                                                  app: Firebase
                                                                      .app(),
                                                                  databaseURL:
                                                                      dbCreaMatchURL)
                                                          .ref()
                                                          .child('Prenotazioni')
                                                          .child('Crea_Match')
                                                          .child(widget
                                                                  .appointment[
                                                              'city'])
                                                          .child('football')
                                                          .child(widget
                                                                  .appointment[
                                                              'dateURL'])
                                                          .update({
                                                        'c${widget.appointment['commentiTot']}_name':
                                                            profile['username'],
                                                        'commentiTot': widget
                                                                    .appointment[
                                                                'commentiTot'] +
                                                            1
                                                      });

                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  355));

                                                      FirebaseDatabase.instanceFor(
                                                              app: Firebase
                                                                  .app(),
                                                              databaseURL:
                                                                  dbCreaMatchURL)
                                                          .ref(
                                                              'Prenotazioni/Crea_Match/${widget.appointment['city']}/football/${widget.appointment['dateURL']}')
                                                          .onValue
                                                          .listen((DatabaseEvent
                                                              event) {
                                                        final data = event
                                                            .snapshot
                                                            .value as Map;
                                                        //print(data);

                                                        appointmentData
                                                            .assignAll(data);
                                                      });

                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  355));

                                                      if (appointmentData
                                                          .isEmpty) {
                                                        appointmentData
                                                            .assignAll(widget
                                                                .appointment);
                                                      }

                                                      //print(appointmentData);
                                                      appointmentData.isEmpty
                                                          ? appointmentData =
                                                              widget.appointment
                                                          : Container();
                                                      //       if (widget.sport == 'football') {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => CommentPage(
                                                                  h: widget.h,
                                                                  w: widget.w,
                                                                  appointment:
                                                                      appointmentData,
                                                                  list1: widget
                                                                      .list1)));
                                                    }
                                                  },
                                                );
                                              } else {
                                                return Container();
                                              }
                                            })))
                                      ],
                                    ),
                                  ],
                                ))
                          else
                            Container(
                              height: widget.h > 700
                                  ? widget.h * 0.15
                                  : widget.h * 0.17,
                              width: widget.w * 0.9,
                              margin: const EdgeInsets.only(
                                  bottom: kDefaultPadding,
                                  top: kDefaultPadding),
                              padding: const EdgeInsets.symmetric(
                                  vertical: kDefaultPadding,
                                  horizontal: kDefaultPadding / 2),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: kBackgroundColor2,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Nessun messaggio',
                                    style: TextStyle(
                                        fontSize: widget.w > 605
                                            ? 22
                                            : widget.w > 385
                                                ? 18
                                                : 12,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: widget.h * 0.05,
                                        width: widget.w * 0.60,
                                        decoration: BoxDecoration(
                                            color: kBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 10,
                                                  spreadRadius: 7,
                                                  offset: const Offset(1, 1),
                                                  color: Colors.grey
                                                      .withOpacity(0.2))
                                            ]),
                                        child: TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                30),
                                          ],
                                          keyboardType: TextInputType.multiline,
                                          controller: chatController,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  widget.w > 385 ? 13 : 10),
                                          decoration: InputDecoration(
                                              hintText:
                                                  "Scrivi un messaggio breve",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30))),
                                        ),
                                      ),
                                      FutureBuilder<DocumentSnapshot>(
                                          future: user.doc(utente).get(),
                                          builder: (((context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              Map<String, dynamic> profile =
                                                  snapshot.data!.data()
                                                      as Map<String, dynamic>;
                                              return GestureDetector(
                                                child: Text(
                                                  " Invia  ",
                                                  style: TextStyle(
                                                      fontSize: widget.w > 605
                                                          ? 25
                                                          : widget.w > 390
                                                              ? 18
                                                              : 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                onTap: () async {
                                                  String commento =
                                                      chatController.text
                                                          .trim();

                                                  if (commento.isNotEmpty) {
                                                    print('go go go');

                                                    await FirebaseDatabase
                                                            .instanceFor(
                                                                app: Firebase
                                                                    .app(),
                                                                databaseURL:
                                                                    dbCreaMatchURL)
                                                        .ref()
                                                        .child('Prenotazioni')
                                                        .child('Crea_Match')
                                                        .child(
                                                            widget.appointment[
                                                                'city'])
                                                        .child('football')
                                                        .child(
                                                            widget.appointment[
                                                                'dateURL'])
                                                        .child('commenti')
                                                        .update({
                                                      'c${widget.appointment['commentiTot']}':
                                                          commento
                                                    });

                                                    await FirebaseDatabase
                                                            .instanceFor(
                                                                app: Firebase
                                                                    .app(),
                                                                databaseURL:
                                                                    dbCreaMatchURL)
                                                        .ref()
                                                        .child('Prenotazioni')
                                                        .child('Crea_Match')
                                                        .child(
                                                            widget.appointment[
                                                                'city'])
                                                        .child('football')
                                                        .child(
                                                            widget.appointment[
                                                                'dateURL'])
                                                        .update({
                                                      'c${widget.appointment['commentiTot']}_name':
                                                          profile['username'],
                                                      'commentiTot': widget
                                                                  .appointment[
                                                              'commentiTot'] +
                                                          1,
                                                    });

                                                    //                    await FirebaseDatabase.instanceFor(
                                                    //                          app: Firebase.app(),
                                                    //                        databaseURL: dbPrenotazioniURL)
                                                    //                  .ref()
                                                    //                .child('Prenotazioni')
                                                    //              .child('Crea_Match')
                                                    //            .child(widget.appointment['city'])
                                                    //          .child('football')
                                                    //        .child(widget.appointment['dateURL'])
                                                    //      .child('commenti')
                                                    //                                   .update({
                                                    //                               'c${widget.appointment['commentiTot']}':
                                                    //                                 commento
                                                    //                         });
//
                                                    //                                await FirebaseDatabase.instanceFor(
                                                    //                                      app: Firebase.app(),
                                                    //                                    databaseURL: dbPrenotazioniURL)
                                                    //                              .ref()
                                                    //                            .child('Prenotazioni')
                                                    //                          .child('Crea_Match')
                                                    //                        .child(widget.appointment['city'])
                                                    //                      .child('football')
                                                    //                    .child(widget.appointment['dateURL'])
                                                    //                  .update({
                                                    //              'c${widget.appointment['commentiTot']}_name':
                                                    //                profile['username'],
                                                    //          'commentiTot':
                                                    //            widget.appointment['commentiTot'] + 1
                                                    //    });

                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 355));

                                                    FirebaseDatabase.instanceFor(
                                                            app: Firebase.app(),
                                                            databaseURL:
                                                                dbCreaMatchURL)
                                                        .ref(
                                                            'Prenotazioni/Crea_Match/${widget.appointment['city']}/football/${widget.appointment['dateURL']}')
                                                        .onValue
                                                        .listen((DatabaseEvent
                                                            event) {
                                                      final data = event
                                                          .snapshot
                                                          .value as Map;
                                                      //print(data);

                                                      appointmentData
                                                          .assignAll(data);
                                                    });

                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 355));

                                                    if (appointmentData
                                                        .isEmpty) {
                                                      appointmentData.assignAll(
                                                          widget.appointment);
                                                    }

                                                    //print(appointmentData);
                                                    appointmentData.isEmpty
                                                        ? appointmentData =
                                                            widget.appointment
                                                        : Container();
                                                    //       if (widget.sport == 'football') {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CommentPage(
                                                                    h: widget.h,
                                                                    w: widget.w,
                                                                    appointment:
                                                                        appointmentData,
                                                                    list1: widget
                                                                        .list1)));
                                                  }
                                                },
                                              );
                                            } else {
                                              return Container();
                                            }
                                          })))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ]))
                      ])))
            ])));
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
