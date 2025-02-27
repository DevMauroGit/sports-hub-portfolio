import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_hub_ios/page/login_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class RegisterMemo extends StatefulWidget {
  const RegisterMemo({
    super.key,
    required this.h,
    required this.w,
  });

  final double h;
  final double w;

  @override
  State<RegisterMemo> createState() => RegisterMemoState();
}

class RegisterMemoState extends State<RegisterMemo> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.2)),
        child: Center(
          child: Container(
              height: widget.h * 0.6,
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
                      horizontal: 10,
                    ),
                    height: widget.h * 0.08,
                    width: widget.w * 0.6,
                    //margin: EdgeInsets.only(top: h*0.02),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: kBackgroundColor2,
                    ),

                    child: DefaultTextStyle(
                      style: TextStyle(
                          fontSize: widget.w > 605
                              ? 18
                              : widget.w > 385
                                  ? 14
                                  : 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      child: const Center(
                        child: Text(
                          'Accedi o Registrati',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: widget.h * 0.02),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    height: widget.h * 0.4,
                    width: widget.w * 0.6,
                    //margin: EdgeInsets.only(top: h*0.02),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: kBackgroundColor2,
                    ),

                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        SizedBox(height: widget.h * 0.025),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: widget.w > 385 ? 15 : 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          child: Center(
                            child: Text(
                              'Devi essere registrato per poter accedere a questi contenuti',
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
                        SizedBox(height: widget.h * 0.04),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              textStyle:
                                  TextStyle(fontSize: widget.w > 385 ? 20 : 16),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () async => Get.to(() => LoginPage()),
                            child: Text(
                              "Vai al Login",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: widget.w > 385 ? 18 : 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                  ),
                  SizedBox(height: widget.h * 0.05),
                ],
              )),
        ));
  }
}
