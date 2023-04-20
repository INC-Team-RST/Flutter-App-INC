import 'package:darkknightspict/api/admin_api.dart';
import 'package:darkknightspict/features/login/admin_widgets/user_list.dart';
import 'package:darkknightspict/project/bottombar_admin.dart';
import 'package:flutter/material.dart';

class Profession extends StatefulWidget {
  String accessToken;
  Profession({Key? key, required this.accessToken}) : super(key: key);

  @override
  State<Profession> createState() => _ProfessionState();
}

class _ProfessionState extends State<Profession> {
  @override
  String dropdownValue = 'DOCTOR';

  List<String> professions = [
    'DOCTOR',
    'LAWYER',
    'TEACHER',
    'ARCHITECT',
    'CA',
    'POLICY_AGENT',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Center(
            child: Text('Select a Profession'),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton(
            items: professions.map((String professions) {
              return DropdownMenuItem(
                  value: professions, child: Text(professions));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            value: dropdownValue,
          ),
          ElevatedButton(
            onPressed: () async {
              //patch request to be implemented

              await updateProfession(
                  profession: dropdownValue, accessToken: widget.accessToken);

              // navigate to the dashboard

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserList(),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
