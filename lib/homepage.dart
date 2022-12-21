import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_auth_firebase/add_note.dart';
import 'package:intl/intl.dart';
import 'package:notes_auth_firebase/google_auth.dart';
import 'package:notes_auth_firebase/login.dart';
import 'package:notes_auth_firebase/read_note.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notes');

  List<Color> colorList = [
    Colors.amber.shade200,
    Colors.orange.shade200,
    Colors.deepOrange.shade200,
    Colors.teal.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.pink.shade200,
    Colors.purple.shade200,
    Colors.blue.shade200,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff3b3b3b),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNote(),
            ),
          ).then((value) {
            print('calling set state');
            setState(() {});
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white70,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Notes',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              signOut().then((value) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              });
            },
            icon: const Icon(
              Icons.logout_rounded,
            ),
          )
        ],
        elevation: 0.0,
        backgroundColor: const Color(0xff252525),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
        child: FutureBuilder<QuerySnapshot>(
          future: ref.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "You have no saved Notes !",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Random random = Random();
                  Color bg = colorList[random.nextInt(9)];
                  Object? data = snapshot.data!.docs[index].data();
                  String title = snapshot.data!.docs[index]['title'];
                  String desc = snapshot.data!.docs[index]['description'];
                  DateTime mydateTime =
                      snapshot.data!.docs[index]['created'].toDate();
                  String formattedTime =
                      DateFormat.yMMMd().add_jm().format(mydateTime);
                  DocumentReference ref = snapshot.data!.docs[index].reference;
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => ViewNote(
                            title: title,
                            desc: desc,
                            data: data,
                            time: formattedTime,
                            ref: ref,
                          ),
                        ),
                      )
                          .then(
                        (value) {
                          setState(() {});
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: bg,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data!.docs[index]['title']}",
                                style: GoogleFonts.poppins(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              //
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  formattedTime,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow[200],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
