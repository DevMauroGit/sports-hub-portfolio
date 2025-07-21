import 'package:flutter/material.dart';
import 'package:sports_hub_ios/utils/constants.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.size,
    required this.phone,
    required this.mail,
  });

  final Size size;
  final bool phone;
  final bool mail;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size.height > 700 ? size.height * 0.24 : size.height * 0.29,
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: size.width > 605 ? kDefaultPadding * 2 : 0,
                      left: size.width > 605
                          ? kDefaultPadding * 2
                          : kDefaultPadding + 10,
                      right: size.width > 605
                          ? kDefaultPadding * 5
                          : kDefaultPadding + 10,
                      bottom: kDefaultPadding),
                  height: size.height > 700
                      ? size.height * 0.2
                      : size.height * 0.22,
                  decoration: BoxDecoration(
                    color: kBackgroundColor2.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: kDefaultPadding + 10),
                      Row(
                        children: <Widget>[
                          const Spacer(),
                          const Spacer(),
                          Text(
                            'SPORTS HUB',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width > 605
                                        ? 50
                                        : size.width > 355
                                            ? 35
                                            : 20,
                                    fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          Image.asset(
                            "assets/images/Sport_hub_logo_1.png",
                            height: size.width > 605
                                ? 100
                                : size.width > 355
                                    ? size.height > 620
                                        ? 80
                                        : 60
                                    : 50,
                            width: size.width > 605
                                ? 100
                                : size.width > 355
                                    ? size.height > 620
                                        ? 80
                                        : 60
                                    : 50,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: size.height > 825
                  ? size.height * 0.002
                  : size.height > 700
                      ? 0
                      : size.height * 0.03,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                height: size.height > 900 ? 80 : 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 50,
                        color: kSecondaryColor),
                  ],
                ),
                child: Text(
                    mail
                        ? 'Verifica mail'
                        : phone
                            ? 'Verifica telefono'
                            : 'Scendi in Campo!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: size.width > 605
                            ? 26
                            : size.width > 355
                                ? 21
                                : 18)),
              ),
            )
          ],
        ));
  }
}
