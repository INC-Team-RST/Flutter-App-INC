import 'package:darkknightspict/api/user_api.dart';
import 'package:darkknightspict/models/admin.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class SelectAdmin extends StatefulWidget {
  String token;
  SelectAdmin({Key? key, required this.token}) : super(key: key);

  @override
  State<SelectAdmin> createState() => _SelectAdminState();
}

class _SelectAdminState extends State<SelectAdmin> {
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff010413),
        title: const Text(
          'Select your Admin',
          style: TextStyle(
              color: Color(0xff5ad0b5),
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Lato'),
        ),
      ),
      body: ElevatedButton(
        onPressed: () async {
          final admins=await getAdmin(widget.token);
          log(admins.toString());
        },
        child: const Text('Get Admins'),
      ),
      // body:FutureBuilder(
      //   future: getAdmin(widget.token),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       final admins=snapshot.data;
      //       log(snapshot.data.toString());
      //       // return ListView.builder(
      //       //   itemCount: admins.length,
      //       //   itemBuilder: (context, index) {
      //       //     return ListTile();
      //       //   },
              
      //       // );
      //     } else {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
          
      //   },
      // ),
    );
  }
}
