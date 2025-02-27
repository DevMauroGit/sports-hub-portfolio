import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_hub_ios/controllers/user_controller.dart';
import 'package:sports_hub_ios/utils/constants.dart';
import 'package:sports_hub_ios/widgets/Requesting_widget/requested_card.dart';

class RequestedWidget extends StatefulWidget {
  const RequestedWidget({
    super.key,
    required this.users,
    required this.allRequest,
  });
  final UserController users;
  final List allRequest;

  @override
  State<RequestedWidget> createState() => _RequestedWidgetState();
}

class _RequestedWidgetState extends State<RequestedWidget> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    final UserController userController = widget.users;

    return SizedBox(
      height: h * 0.1,
      width: w * 0.75,
      child: StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('errore caricamento dati');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              margin: const EdgeInsets.all(kDefaultPadding),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          //print('requests: ${widget.allRequest}');
          return Container(
              margin: const EdgeInsets.only(left: kDefaultPadding),
              height: h * 0.1,
              width: w * 0.75,
              child: AspectRatio(
                aspectRatio: 0.50,
                child: Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: widget.allRequest.length,
                    itemBuilder: (
                      BuildContext context,
                      index,
                    ) =>
                        RequestedCard(
                      user: widget.allRequest[index],
                      userController: userController,
                    ),
                  ),
                ),
              ));
        },
        stream: null,
      ),
    );
  }
}
