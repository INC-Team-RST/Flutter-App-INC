import 'package:darkknightspict/api/user_api.dart';
import 'package:darkknightspict/features/login/widgets/filter_admins.dart';
import 'package:flutter/material.dart';

class SelectAdmin extends StatefulWidget {
  String token;
  SelectAdmin({Key? key, required this.token}) : super(key: key);

  @override
  State<SelectAdmin> createState() => _SelectAdminState();
}

class _SelectAdminState extends State<SelectAdmin> {
  late Future admins;
  @override
  void initState() {
    admins = getAdmin(widget.token);
    super.initState();
  }

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
      // body: ElevatedButton(
      //   onPressed: () async {
      //     final admins=await getAdmin(widget.token);
      //     log(admins.toString());
      //   },
      //   child: const Text('Get Admins'),
      // ),
      // body: FutureBuilder(
      //   future: admins,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       log(snapshot.data.toString());

      //       // return ListView.builder(
      //       //   itemBuilder: (context, index) {
      //       //     return Container(
      //       //       child: const Text('Muhahahahahaha'),
      //       //     );
      //       //   },
      //       // );
      //     } else {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const FilterAdmin()));
          },
          label: const Text('Add Admin')),
    );
  }
}
