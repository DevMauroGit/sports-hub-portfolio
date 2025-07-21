import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sports_hub_ios/controllers/profile_controller.dart';
import 'package:sports_hub_ios/models/user_model.dart';
import 'package:sports_hub_ios/page/home_page.dart';
import 'package:sports_hub_ios/page/profile_page.dart';
import 'package:sports_hub_ios/utils/constants.dart';

const List<String> list = <String>[
  'Città o provincia',
  'Pavia',
  'Milano',
  'Lodi'
];

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.docIds});

  final String docIds;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final double coverHeight = 250;
  final double profileHeight = 144;

  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String profile = docIds.first;

  PlatformFile? pickedCoverFile;
  PlatformFile? pickedProfileFile;
  UploadTask? uploadTask;
  String profilePic = '';
  String coverPic = '';

  bool isProfileSelected = false;
  bool isCoverSelected = false;

  /// Select a new cover image using file picker
  Future selectCoverFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedCoverFile = result.files.first;
      isCoverSelected = true;
    });

    // Triggers the upload (though this FutureBuilder is unused in the widget tree)
    FutureBuilder(
      future: uploadCoverFile(),
      builder: ((context, snapshot) {
        setState(() async {
          coverPic = snapshot.data.toString();
        });
        return Container();
      }),
    );
  }

  /// Upload selected cover image to Firebase Storage
  Future uploadCoverFile() async {
    try {
      final path = 'users_images/${pickedCoverFile!.name}';
      final file = File(pickedCoverFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() => null);
      final urlDownload = await snapshot.ref.getDownloadURL();

      setState(() {
        coverPic = urlDownload;
      });

      return coverPic;
    } catch (e) {}
  }

  /// Select a new profile image using file picker
  Future selectProfileFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedProfileFile = result.files.first;
      isProfileSelected = true;
    });

    FutureBuilder(
      future: uploadProfileFile(),
      builder: ((context, snapshot) {
        setState(() {
          profilePic = snapshot.data.toString();
        });
        return Container();
      }),
    );
  }

  /// Upload selected profile image to Firebase Storage
  Future uploadProfileFile() async {
    try {
      final path = 'users_images/${pickedProfileFile!.name}';
      final file = File(pickedProfileFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() => null);
      final urlDownload = await snapshot.ref.getDownloadURL();

      setState(() {
        profilePic = urlDownload;
      });

      return profilePic;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 200));

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    CollectionReference user = FirebaseFirestore.instance.collection(('User'));
    final controller = Get.put(ProfileController());

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: TopBar(),
        bottomNavigationBar: BottomBar(context),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Load user data from Firestore
            FutureBuilder<DocumentSnapshot>(
                future: user.doc(profile).get(),
                builder: (((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> profile =
                        snapshot.data!.data() as Map<String, dynamic>;

                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        // Display cover image (remote or selected)
                        if (pickedCoverFile == null)
                          Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: GestureDetector(
                                onTap: () async {
                                  await selectCoverFile();
                                },
                                child: Container(
                                  color: Colors.grey,
                                  child: CachedNetworkImage(
                                    imageUrl: profile['cover_pic'],
                                    width: w * 0.6,
                                    height: h * 0.2,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )),
                        if (pickedCoverFile != null)
                          Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: GestureDetector(
                                onTap: () {
                                  selectCoverFile();
                                },
                                child: Container(
                                  color: Colors.grey,
                                  child: Image.file(
                                    File(pickedCoverFile!.path!),
                                    width: w * 0.6,
                                    height: h * 0.2,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )),

                        // Display profile image (remote or selected)
                        if (pickedProfileFile == null)
                          Container(
                              margin: const EdgeInsets.only(top: 210),
                              child: GestureDetector(
                                  onTap: () {
                                    selectProfileFile();
                                  },
                                  child: SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: ClipOval(
                                          child: CircleAvatar(
                                        radius: profileHeight / 2,
                                        backgroundColor: kPrimaryColor,
                                        child: CachedNetworkImage(
                                          imageUrl: profile['profile_pic'],
                                          fit: BoxFit.fill,
                                        ),
                                      ))))),
                        if (pickedProfileFile != null)
                          Container(
                              margin: const EdgeInsets.only(top: 210),
                              child: GestureDetector(
                                  onTap: () async {
                                    selectProfileFile();
                                  },
                                  child: SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: ClipOval(
                                        child: Image.file(
                                          File(pickedProfileFile!.path!),
                                          fit: BoxFit.fill,
                                        ),
                                      )))),
                      ],
                    );
                  }
                  return Container();
                }))),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextandSave(
                    h: h,
                    w: w,
                    user: user,
                    profilePic: profilePic,
                    coverPic: coverPic,
                    controller: controller,
                    isProfileSelected: isProfileSelected,
                    isCoverSelected: isCoverSelected,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextandSave extends StatefulWidget {
  const TextandSave({
    super.key,
    required this.h,
    required this.w,
    required this.user,
    required this.profilePic,
    required this.controller,
    required this.isProfileSelected,
    required this.isCoverSelected,
    required this.coverPic,
  });

  final double h;
  final double w;
  final CollectionReference<Object?> user;
  final bool isProfileSelected;
  final bool isCoverSelected;
  final String profilePic;
  final String coverPic;
  final ProfileController controller;

  @override
  State<TextandSave> createState() => _TextandSaveState();
}

class _TextandSaveState extends State<TextandSave> {
  var usernameController = TextEditingController();
  var cityController = TextEditingController();

  String dropdownValue = 'Città o provincia';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.w * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Username',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),

          // Username input field with validation
          TextFormField(
            inputFormatters: <TextInputFormatter>[UpperCaseTextFormatter()],
            controller: usernameController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: '',
              prefixIcon: const Icon(Icons.person, color: kPrimaryColor),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (username) => username != null && username.length < 4
                ? 'Il Nome Utente deve essere di almeno 4 lettere'
                : username != null && username.length > 10
                    ? 'Il Nome Utente deve essere di massimo 10 lettere'
                    : null,
          ),

          const SizedBox(height: 10),
          const Text(
            'Città o Provincia',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),

          // Dropdown for selecting a city/province
          Container(
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 7,
                  offset: const Offset(1, 1),
                  color: Colors.grey.withOpacity(0.2),
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.location_city,
                    color: Colors.deepOrangeAccent, size: 30),
                Container(
                  width: widget.w * 0.55,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 8,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: widget.w > 355 ? 16 : 13,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Load user data again and create the save button
          FutureBuilder<DocumentSnapshot>(
            future: widget.user.doc(docIds.first).get(),
            builder: (((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> profile =
                    snapshot.data!.data() as Map<String, dynamic>;

                return Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: widget.w * 0.2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBackgroundColor2,
                        textStyle: const TextStyle(fontSize: 15),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        // Prepare values before updating
                        String profilePic = widget.profilePic;
                        String coverPic = widget.coverPic;
                        String city = '';
                        String username = '';

                        if (profilePic.length < 10 ||
                            !widget.isProfileSelected) {
                          profilePic = profile['profile_pic'];
                        }
                        if (coverPic.length < 10 || !widget.isCoverSelected) {
                          coverPic = profile['cover_pic'];
                        }
                        if (dropdownValue.toString().length < 10) {
                          city = dropdownValue.toString();
                        } else {
                          city = profile['city'];
                        }
                        if (usernameController.text.trim().length > 2) {
                          username = usernameController.text.trim();
                        } else {
                          username = profile['username'];
                        }

                        // Create updated user model
                        UserModel userData = UserModel(
                          username: username,
                          id: profile['id'],
                          email: profile['email'],
                          phoneNumber: profile['phoneNumber'],
                          city: city,
                          password: profile['password'],
                          profile_pic: profilePic,
                          cover_pic: coverPic,
                          isEmailVerified: true,
                          games: profile['games'],
                          goals: profile['goals'],
                          win: profile['win'],
                          games_tennis: profile['games_tennis'],
                          set_vinti: profile['set_vinti'],
                          win_tennis: profile['win_tennis'],
                          prenotazioni: profile['prenotazioni'],
                          prenotazioniPremium: profile['prenotazioniPremium'],
                          token: profile['token'],
                        );

                        // Check validation before saving
                        if (4 < usernameController.text.trim().length &&
                            usernameController.text.trim().length < 10) {
                          await widget.controller.updateUser(userData);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                docIds: docIds.first,
                                avviso: false,
                                sport: 'football',
                              ),
                            ),
                          );
                        } else {
                          // Show error message
                          Get.snackbar(
                            '',
                            '',
                            snackPosition: SnackPosition.TOP,
                            titleText: Text(
                              'Inserisci un Username valido',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                fontSize: widget.w < 380
                                    ? 13
                                    : widget.w > 605
                                        ? 18
                                        : 15,
                              ),
                            ),
                            messageText: const Text(''),
                            duration: const Duration(seconds: 4),
                            backgroundColor: Colors.redAccent.withOpacity(0.6),
                            colorText: Colors.black,
                          );
                        }
                      },
                      child: const Text(
                        "SALVA",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Container();
            })),
          ),
        ],
      ),
    );
  }
}

// Formatter to capitalize the first letter of the text input
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

// Capitalizes the first letter of a string
String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
