// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

const storage = FlutterSecureStorage();

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class UserMyDocs extends StatefulWidget {
  const UserMyDocs({Key? key, required this.adminId}) : super(key: key);

  final int adminId;

  @override
  State<UserMyDocs> createState() => _UserMyDocsState();
}

class _UserMyDocsState extends State<UserMyDocs> {
  late Future<List> docs;

  @override
  void initState() {
    super.initState();
    docs = getDocs();
  }

  Future<List> getDocs() async {
    String? token = await storage.read(key: 'user_access_token');
    final Dio dio = Dio();

    log(token!.toString());

    dio.options.headers['Authorization'] = 'Bearer $token';

    Response response = await dio.post(
        "https://client-hive.onrender.com/api/user/document/shared",
        data: {
          "admin_id": widget.adminId,
        });
    log(response.toString());
    log(response.data.toString());
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    // final userUID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff010413),
        title: const Text(
          'Documents',
          style: TextStyle(
              color: Color(0xff5ad0b5),
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Lato'),
        ),
      ),
      backgroundColor: const Color(0xff010413),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List>(
          future: docs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!;
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No Documents',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _launchURL(data[index]['url']);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 15,
                        ),
                        height: MediaQuery.of(context).size.width * 0.15,
                        decoration: const BoxDecoration(
                          color: Color(0xff403ffc),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          children: [
                            if (data[index]['name'].split(".").last == 'jpg' ||
                                data[index]['name'].split(".").last == 'jepg')
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                child: Image.asset(
                                  'assets/images/jpg_icon.png',
                                ),
                              ),
                            if (data[index]['name'].split(".").last == 'doc')
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                padding: const EdgeInsets.only(
                                  right: 2,
                                ),
                                child: Image.asset(
                                  'assets/images/doc_icon.png',
                                ),
                              ),
                            if (data[index]['name'].split(".").last == 'pdf')
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                padding: const EdgeInsets.only(
                                  right: 2,
                                ),
                                child: Image.asset(
                                  'assets/images/pdf_icon.png',
                                ),
                              ),
                            if (data[index]['name'].split(".").last == 'docx')
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                padding: const EdgeInsets.only(
                                  right: 2,
                                ),
                                child: Image.asset(
                                  'assets/images/docx_icon.png',
                                ),
                              ),
                            if (data[index]['name'].split(".").last == 'xls')
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                child: Image.asset(
                                  'assets/images/xls_icon.png',
                                ),
                              ),
                            if (data[index]['name'].split(".").last == 'xlsx')
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                padding: const EdgeInsets.only(
                                  right: 2,
                                ),
                                child: Image.asset(
                                  'assets/images/xlsx_icon.png',
                                ),
                              ),
                            if (data[index]['name'].split(".").last == 'csv')
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                padding: const EdgeInsets.only(
                                  right: 2,
                                ),
                                child: Image.asset(
                                  'assets/images/csv_icon.png',
                                ),
                              ),
                            if (data[index]['name'].split(".").last == 'ppt')
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                padding: const EdgeInsets.only(
                                  right: 2,
                                ),
                                child: Image.asset(
                                  'assets/images/ppt_icon.png',
                                ),
                              ),
                            if (data[index]['name'].split(".").last == 'pptx')
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                padding: const EdgeInsets.only(
                                  right: 2,
                                ),
                                child: Image.asset(
                                  'assets/images/pptx_icon.png',
                                ),
                              ),
                            if (data[index]['name'].split(".").last != 'jpg' &&
                                data[index]['name'].split(".").last != 'jepg' &&
                                data[index]['name'].split(".").last != 'pdf' &&
                                data[index]['name'].split(".").last != 'docx' &&
                                data[index]['name'].split(".").last != 'doc' &&
                                data[index]['name'].split(".").last != 'xls' &&
                                data[index]['name'].split(".").last != 'xlsx' &&
                                data[index]['name'].split(".").last != 'csv' &&
                                data[index]['name'].split(".").last != 'pptx' &&
                                data[index]['name'].split(".").last != 'ppt')
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                padding: const EdgeInsets.only(
                                  right: 2,
                                ),
                                child: Image.asset(
                                  'assets/images/file_icon.png',
                                ),
                              ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      data[index]['name'].split(".").first,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lato',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '.${data[index]['name'].split(".").last} file',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Lato',
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }
            return const Text("NO DATA");
          },
        ),
      ),
    );
  }
}
