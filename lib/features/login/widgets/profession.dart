// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/material.dart';

import '../../../api/admin_api.dart';
import '../admin_widgets/user_list.dart';

class Profession extends StatefulWidget {
  final String accessToken;
  const Profession({
    Key? key,
    required this.accessToken,
  }) : super(key: key);

  @override
  State<Profession> createState() => _ProfessionState();
}

class _ProfessionState extends State<Profession> {
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
      appBar: AppBar(
        backgroundColor: const Color(0xff010413),
        title: const Text(
          'Your Profession',
          style: TextStyle(
            color: Color(0xff5ad0b5),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Lato',
          ),
        ),
      ),
      backgroundColor: const Color(0xff010413),
      body: Column(
        children: [
          const Center(
            child: Text(
              'What is your profession?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton(
            items: professions.map(
              (String professions) {
                return DropdownMenuItem(
                  value: professions,
                  child: Text(professions),
                );
              },
            ).toList(),
            onChanged: (String? newValue) {
              setState(
                () {
                  dropdownValue = newValue!;
                },
              );
            },
            value: dropdownValue,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              // update the profession
              await updateProfession(
                profession: dropdownValue,
                accessToken: widget.accessToken,
              );

              // navigate to the dashboard
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserList(),
                ),
              );
            },
            // Decoration, make it circular and color of teal color
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              backgroundColor: const Color(0xff5ad0b5),
              padding: const EdgeInsets.all(15),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
