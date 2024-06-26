import 'dart:io';
import 'package:chat_app/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class profilesetting extends StatefulWidget {
  const profilesetting({
    super.key,
  });

  @override
  State<profilesetting> createState() => _profilesettingState();
}

class _profilesettingState extends State<profilesetting> {
  String? imageUrl = '';
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (ModalRoute.of(context)!.isCurrent) {
      imageUrl = await getPfpUrl();
      setState(() {});
    }
  }

  Future<String?> getField(String field) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('users');

      DocumentSnapshot documentSnapshot =
          await collection.doc(user?.uid ?? 'empty').get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        String item = await documentSnapshot[field];
        setState(() {});
        return (item);
      } else {
        print('item not there');
      }
    } catch (e) {
      print('Error reading data: $e');
    }
  }

  Future<void> editUserDataField(String field, String update) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      await usersCollection.doc(user?.uid ?? 'empty').update({
        field: update,
      });

      print('updated successfully');
      setState(() {});
    } catch (e) {
      print('Error updating user pfpurl: $e');
    }
  }

  Future<String?> getImage(source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');

      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);

      try {
        await referenceImageToUpload.putFile(File(file!.path));
        imageUrl = await referenceImageToUpload.getDownloadURL();
      } catch (error) {
        // some error
      }

      return (imageUrl);
    }
  }

  Future<String?> getPfpUrl() async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection('users');

      DocumentSnapshot documentSnapshot =
          await collection.doc(user?.uid ?? 'empty').get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        String pfpurl = await documentSnapshot['pfpurl'];
        setState(() {});
        return (pfpurl);
      } else {
        print('pfp not there');
      }
    } catch (e) {
      print('Error reading data: $e');
    }
  }

  void openMediaDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Choose'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () async {
                      String? imagePath = await getImage(ImageSource.camera);
                      print(imagePath);
                      if (imagePath != null) {
                        print('edit image path running');
                        editUserDataField('pfpurl', await imagePath);
                        setState(() {});
                      } else {
                        print(
                            'Image path is null. Cannot update user profile picture.');
                      }
                    },
                    child: Icon(
                      Icons.camera_alt,
                      size: 30,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      String? imagePath = await getImage(ImageSource.gallery);

                      if (imagePath != null) {
                        editUserDataField('pfpurl', await imagePath);
                        setState(() {});
                      } else {
                        print(
                            'Image path is null. Cannot update user profile picture.');
                      }
                    },
                    child: Icon(
                      Icons.aspect_ratio,
                      size: 30,
                    ),
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 254, 254, 254),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  const Color.fromARGB(255, 57, 57, 57)!,
                  const Color.fromARGB(255, 28, 28, 28)!,
                  const Color.fromARGB(255, 0, 0, 0)!,
                ],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 400,
                  width: MediaQuery.sizeOf(context).width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      openMediaDialog();
                      imageUrl = await getPfpUrl();
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 130,
                      backgroundImage: NetworkImage(imageUrl ?? 'empty'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.sizeOf(context).height - 496,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.298),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        height: 40,
                        width: 400,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              hintText: "Enter Username",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () async {
                          String username = usernameController.text;
                          print(username);

                          editUserDataField(
                              'username', usernameController.text);
                          print('sudah');

                          getField('pfpurl');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Color.fromARGB(255, 254, 254, 254),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.294),
                                blurRadius: 10,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          height: 40,
                          width: 400,
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
