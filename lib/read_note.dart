import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewNote extends StatefulWidget {
  final Object? data;
  final String time;
  final String title;
  final String desc;
  final DocumentReference<Object?> ref;

  const ViewNote(
      {super.key,
      this.data,
      required this.time,
      required this.ref,
      required this.title,
      required this.desc});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  late String title;
  late String desc;

  bool edit = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    title = widget.title;
    desc = widget.desc;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: edit
            ? FloatingActionButton(
                backgroundColor: Colors.blueAccent.shade200,
                onPressed: save,
                child: const Icon(
                  Icons.save_rounded,
                  color: Colors.white,
                ),
              )
            : null,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3b3b3b),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                edit = !edit;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.only(right: 1),
                              backgroundColor: const Color(0xff3b3b3b),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Icon(Icons.edit_note_rounded),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.only(right: 1),
                              backgroundColor: Colors.red.shade300,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Icon(Icons.delete_forever),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Title',
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        initialValue: widget.title,
                        enabled: edit,
                        onChanged: (_val) {
                          title = _val;
                        },
                        validator: (_val) {
                          if (_val != null && _val.isEmpty) {
                            return "Cant be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          widget.time,
                          style: GoogleFonts.poppins(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: TextFormField(
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Note Description',
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[350],
                          ),
                          initialValue: widget.desc,
                          onChanged: (_val) {
                            desc = _val;
                          },
                          enabled: edit,
                          maxLines: 20,
                          validator: (_val) {
                            if (_val != null && _val.isEmpty) {
                              return "Cant be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void delete() async {
    widget.ref.delete();
    Navigator.pop(context);
  }

  void save() async {
    if (key.currentContext != null) {
      await widget.ref.update(
        {
          'title': title,
          'description': desc,
        },
      );
      Navigator.of(context).pop();
    }
  }
}
