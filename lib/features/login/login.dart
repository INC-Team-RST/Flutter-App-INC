import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:darkknightspict/features/login/widgets/select_admin.dart';
import 'package:flutter/material.dart';

import '../../project/bottombar_admin.dart';
import '../../services/google_signin.dart';
import 'dart:developer';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  ApiUser user = ApiUser();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              color: const Color(0xff010413),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.90,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Image.asset("assets/images/login2.jpg"),
                            ),
                          ),
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                "Client-Hive",
                                speed: const Duration(milliseconds: 150),
                                textStyle: const TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff010413)),
                              )
                            ],
                            isRepeatingAnimation: true,
                            repeatForever: true,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text(
                              "\"Share files, not headaches! Connect, Collaborate and Communicate with your Clients seamlessly.\"",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Lato',
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xff010413)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Spacer(),
                          const Spacer(),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: const Color(0xff010413),
                                borderRadius: BorderRadius.circular(25)),
                            child: InkWell(
                              onTap: () async {
                                String token =
                                    await SignIn().signInWithGoogleUser();
                                  log(token);
                                // .then((isNewUser) => {
                                //       if (!isNewUser)
                                //         {

                                //           Navigator.pushReplacement(
                                //             context,
                                //             MaterialPageRoute(
                                //               builder: (context) =>
                                //                   const BottomBar(),
                                //             ),
                                //           ),
                                //         }
                                //       else
                                //         {
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         SelectAdmin(token: token),
                                //   ),
                                // );
                                // }
                                // });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.asset(
                                            "assets/images/google.png")),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Sign-In with Google",
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: const Color(0xff010413),
                                borderRadius: BorderRadius.circular(25)),
                            child: InkWell(
                              onTap: () {
                                // TODO: Add admin page
                                SignIn().signInWithGoogleAdmin().then(
                                      (_) => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomBarCA(),
                                        ),
                                      ),
                                    );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.asset(
                                            "assets/images/Admin.png")),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  const Text("Admin Login",
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
