import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/file_picker_user.dart';

const storage = FlutterSecureStorage();

_launchURL(url) async {
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class FileHome extends StatefulWidget {
  const FileHome({Key? key}) : super(key: key);

  @override
  State<FileHome> createState() => _FileHomeState();
}

class _FileHomeState extends State<FileHome> {
  late Future<List> docs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    docs = getDocs();
  }

  Future<List> getDocs() async {
    String? token = await storage.read(key: 'user_access_token');
    final Dio dio = Dio();

    log(token!.toString());

    dio.options.headers['Authorization'] = 'Bearer $token';

    Response response =
        await dio.get("https://client-hive.onrender.com/api/user/document");
    log(response.toString());
    log(response.data.toString());
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    bool showFab = true;

    Widget getFAB() {
      if (showFab) {
        return FloatingActionButton.extended(
          onPressed: () async {
            await selectFile();
            if (!mounted) return;
            await uploadFile(context, userUID, 'user');
          },
          label: const Text(
            'Upload',
            style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          icon: const Icon(
            Icons.upload,
          ),
        );
      } else {
        return Container();
      }
    }

    const List<Tab> tabs = <Tab>[
      Tab(
          child: Text(
        'My Documents',
        style: TextStyle(
          fontFamily: 'Lato',
        ),
      )),
      Tab(
        child: Text(
          'Admin issued Documents',
          style: TextStyle(
            fontFamily: 'Lato',
          ),
        ),
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (tabController.index == 0) {
            setState(() {
              showFab = true;
            });
          } else {
            setState(() {
              showFab = false;
            });
          }
        });
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
            bottom: const TabBar(
              tabs: tabs,
            ),
          ),
          body: TabBarView(
            children: tabs.map((Tab tab) {
              return Container(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                color: const Color(0xff010413),
                child: FutureBuilder<List>(
                  future: docs,
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData && snapshot.data != null) {
                      final data = snapshot.data!;
                      if(snapshot.data!.isEmpty){
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

                      print(data[0]["url"]);

                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {

                            return Container(
                              child: (data[index]['owner'] == 'USER' &&
                                      tabController.index == 0)
                                  ? InkWell(
                                      onTap: () {
                                        _launchURL(data[index]['url']);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 15,
                                        ),
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        decoration: const BoxDecoration(
                                          color: Color(0xff403ffc),
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Row(
                                          children: [
                                            if (data[index]['name']
                                                        .split(".")
                                                        .last ==
                                                    'jpg' ||
                                                data[index]['name']
                                                        .split(".")
                                                        .last ==
                                                    'jepg')
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/jpg_icon.png',
                                                ),
                                              ),
                                            if (data[index]['name']
                                                    .split(".")
                                                    .last ==
                                                'doc')
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                            if (data[index]['name']
                                                    .split(".")
                                                    .last ==
                                                'pdf')
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                            if (data[index]['name']
                                                    .split(".")
                                                    .last ==
                                                'docx')
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                            if (data[index]['name']
                                                    .split(".")
                                                    .last ==
                                                'xls')
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/xls_icon.png',
                                                ),
                                              ),
                                            if (data[index]['name']
                                                    .split(".")
                                                    .last ==
                                                'xlsx')
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                            if (data[index]['name']
                                                    .split(".")
                                                    .last ==
                                                'csv')
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                            if (data[index]['name']
                                                    .split(".")
                                                    .last ==
                                                'ppt')
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                            if (data[index]['name']
                                                    .split(".")
                                                    .last ==
                                                'pptx')
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                            if (data[index]['name']
                                                        .split(".")
                                                        .last !=
                                                    'jpg' &&
                                                data[index]['name']
                                                        .split(".")
                                                        .last !=
                                                    'jepg' &&
                                                data[index]['name']
                                                        .split(".")
                                                        .last !=
                                                    'pdf' &&
                                                data[index]['name']
                                                        .split(".")
                                                        .last !=
                                                    'docx' &&
                                                data[index]['name']
                                                        .split(".")
                                                        .last !=
                                                    'doc' &&
                                                data[index]['name']
                                                        .split(".")
                                                        .last !=
                                                    'xls' &&
                                                data[index]['name']
                                                        .split(".")
                                                        .last !=
                                                    'xlsx' &&
                                                data[index]['name']
                                                        .split(".")
                                                        .last !=
                                                    'csv' &&
                                                data[index]['name']
                                                        .split(".")
                                                        .last !=
                                                    'pptx' &&
                                                data[index]['name']
                                                        .split(".")
                                                        .last !=
                                                    'ppt')
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FittedBox(
                                                    child: Text(
                                                      data[index]['name']
                                                          .split(".")
                                                          .first,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Lato',
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '.${data[index]['name'].split(".").last} file',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    )
                                  : Container(
                                      child: (data[index]['owner'] == 'ADMIN' &&
                                              tabController.index == 1)
                                          ? InkWell(
                                              onTap: () {
                                                _launchURL(data[index]['url']);
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 15,
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xff403ffc),
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    if (data[index]['name']
                                                                .split(".")
                                                                .last ==
                                                            'jpg' ||
                                                        data[index]['name']
                                                                .split(".")
                                                                .last ==
                                                            'jepg')
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/jpg_icon.png',
                                                        ),
                                                      ),
                                                    if (data[index]['name']
                                                            .split(".")
                                                            .last ==
                                                        'doc')
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 2,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/doc_icon.png',
                                                        ),
                                                      ),
                                                    if (data[index]['name']
                                                            .split(".")
                                                            .last ==
                                                        'pdf')
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 2,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/pdf_icon.png',
                                                        ),
                                                      ),
                                                    if (data[index]['name']
                                                            .split(".")
                                                            .last ==
                                                        'docx')
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 2,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/docx_icon.png',
                                                        ),
                                                      ),
                                                    if (data[index]['name']
                                                            .split(".")
                                                            .last ==
                                                        'xls')
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/xls_icon.png',
                                                        ),
                                                      ),
                                                    if (data[index]['name']
                                                            .split(".")
                                                            .last ==
                                                        'xlsx')
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 2,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/xlsx_icon.png',
                                                        ),
                                                      ),
                                                    if (data[index]['name']
                                                            .split(".")
                                                            .last ==
                                                        'csv')
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 2,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/csv_icon.png',
                                                        ),
                                                      ),
                                                    if (data[index]['name']
                                                            .split(".")
                                                            .last ==
                                                        'ppt')
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 2,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/ppt_icon.png',
                                                        ),
                                                      ),
                                                    if (data[index]['name']
                                                            .split(".")
                                                            .last ==
                                                        'pptx')
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 2,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/pptx_icon.png',
                                                        ),
                                                      ),
                                                    if (data[index]['name']
                                                                .split(".")
                                                                .last !=
                                                            'jpg' &&
                                                        data[index]['name']
                                                                .split(".")
                                                                .last !=
                                                            'jepg' &&
                                                        data[index]['name']
                                                                .split(".")
                                                                .last !=
                                                            'pdf' &&
                                                        data[index]['name']
                                                                .split(".")
                                                                .last !=
                                                            'docx' &&
                                                        data[index]['name']
                                                                .split(".")
                                                                .last !=
                                                            'doc' &&
                                                        data[index]['name']
                                                                .split(".")
                                                                .last !=
                                                            'xls' &&
                                                        data[index]['name']
                                                                .split(".")
                                                                .last !=
                                                            'xlsx' &&
                                                        data[index]['name']
                                                                .split(".")
                                                                .last !=
                                                            'csv' &&
                                                        data[index]['name']
                                                                .split(".")
                                                                .last !=
                                                            'pptx' &&
                                                        data[index]['name']
                                                                .split(".")
                                                                .last !=
                                                            'ppt')
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 2,
                                                        ),
                                                        child: Image.asset(
                                                          'assets/images/file_icon.png',
                                                        ),
                                                      ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          FittedBox(
                                                            child: Text(
                                                              data[index]
                                                                      ['name']
                                                                  .split(".")
                                                                  .first,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Lato',
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '.${data[index]['name'].split(".").last} file',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: 12.5,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : null,
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
              );
            }).toList(),
          ),
          floatingActionButton: tabController.index == 0 ? getFAB() : null,
        );
      }),
    );
  }
}