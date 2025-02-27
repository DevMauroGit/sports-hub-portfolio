import 'package:flutter/material.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class AppTutorial extends StatefulWidget {
  const AppTutorial({
    super.key,
    required this.h,
    required this.w,
  });

  final double h;
  final double w;

  @override
  State<AppTutorial> createState() => AppTutorialState();
}

class AppTutorialState extends State<AppTutorial> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
          child: Container(
              height: widget.h * 0.7,
              width: widget.w * 0.8,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: kPrimaryColor.withOpacity(0.7),
              ),
              child: Column(
                children: [
                  SizedBox(height: widget.h * 0.03),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    height: widget.h * 0.042,
                    width: widget.w * 0.6,
                    //margin: EdgeInsets.only(top: h*0.02),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: kBackgroundColor2,
                    ),

                    child: DefaultTextStyle(
                      style: TextStyle(
                          fontSize: widget.w > 605
                              ? 20
                              : widget.w > 385
                                  ? 16
                                  : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      child: const Center(
                        child: Text(
                          'APP TUTORIAL',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: widget.h * 0.02),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    height: widget.h * 0.53,
                    width: widget.w * 0.6,
                    //margin: EdgeInsets.only(top: h*0.02),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: kBackgroundColor2,
                    ),

                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 385 ? 15 : 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          child: Center(
                            child: Text(
                              'Benvenuto nell\'applicazione dedicata allo sport! Con questa app avrai la possibilità di prenotare il campo per le tue partite, gestire le tue prenotazioni e tenere traccia dei risultati delle partite disputate. \nGrazie al menu posizionato in basso allo schermo, potrai navigare facilmente tra le varie sezioni dell\'applicazione. Seleziona la sezione "Home" per cercare i Clubs, vedere i campi disponibili e prenotare il tuo preferito. Ricorda che è possibile prenotare un campo solo se l\'orario è disponibile e entro un limite di tempo prima dell\'inizio della partita.\nGestisci i tuoi amici accedendo alla sezione dedicata dal profilo in alto a destra.\nCrea partite per cercare giocatori, visualizza chatta e candidati dalla sezione ricerca.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 20
                                    : widget.w > 385
                                        ? 15
                                        : 13,
                              ),
                            ),
                          ),
                        ),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 20
                                  : widget.w > 385
                                      ? 15
                                      : 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          child: Center(
                            child: Text(
                              'Se dovessi cambiare programma o non poter più partecipare alla partita prenotata, potrai cancellare la tua prenotazione entro un tempo limite stabilito prima dell\'inizio della partita. Una volta completata la partita, avrai la possibilità di inserire i giocatori e i risultati della partita che hai prenotato. Potrai anche confermare i risultati delle partite a cui hai preso parte, garantendo così l\'aggiornamento accurato degli incontri. Personalizza il tuo account selezionando un nome utente e caricando immagini per la tua copertina e il tuo profilo. In questo modo potrai rendere il tuo profilo unico e distintivo. Aggiungi i tuoi amici e seguine i progressi nelle diverse discipline.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 20
                                    : widget.w > 385
                                        ? 15
                                        : 13,
                              ),
                            ),
                          ),
                        ),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 20
                                  : widget.w > 385
                                      ? 15
                                      : 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          child: Center(
                            child: Text(
                              '\nPer ogni informazione o problema aiutaci a crescere e contatta il nostro Help Center scrivendo una mail a \n',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 20
                                    : widget.w > 385
                                        ? 15
                                        : 13,
                              ),
                            ),
                          ),
                        ),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 605
                                  ? 20
                                  : widget.w > 385
                                      ? 15
                                      : 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          child: Center(
                            child: Text(
                              'helpcenter.sportshub\n@gmail.com\n',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widget.w > 605
                                    ? 20
                                    : widget.w > 385
                                        ? 15
                                        : 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                  SizedBox(height: widget.h * 0.05),
                ],
              )),
        ));
  }
}
