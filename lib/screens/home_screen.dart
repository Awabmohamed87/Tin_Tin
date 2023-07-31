import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/bubbles/contact_bubble.dart';
import 'package:chat_app/widgets/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String res = '';
  Future getName(id) async {
    final result = await FirebaseFirestore.instance.doc('/users/$id').get();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
        drawer: MyDrawer(scaffoldKey: scaffoldKey),
        appBar: AppBar(
          leading: Center(
            child: InkWell(
                child: Stack(alignment: Alignment.bottomRight, children: [
                  const Icon(
                    Icons.people,
                    size: 30,
                  ),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                  )
                ]),
                onTap: () => scaffoldKey.currentState!.openDrawer()),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Chats',
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            DropdownButton(
                icon: const Icon(Icons.more_vert),
                items: const [
                  DropdownMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 10),
                        Text('Profile')
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10),
                        Text('LogOut')
                      ],
                    ),
                  )
                ],
                onChanged: (value) {
                  if (value == 'logout') {
                    FirebaseAuth.instance.signOut();
                  } else if (value == 'profile') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const ProfileScreen()));
                  }
                })
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(
                    '/chats/${FirebaseAuth.instance.currentUser!.uid}/contacts')
                .snapshots(),
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [CircularProgressIndicator()]),
                      )
                    : snapshot.data!.docs.isEmpty
                        ? const Text('There is no contacts')
                        : ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => FutureBuilder(
                              builder: (context, snp) {
                                if (snp.connectionState !=
                                    ConnectionState.waiting) {
                                  return ContactBubble(
                                    contactName: snp.data['username'],
                                    contactId: snapshot.data!.docs[index].id,
                                    userProfile: snp.data['profileImage'],
                                  );
                                }
                                return Container();
                              },
                              future: getName(snapshot.data!.docs[index].id),
                            ),
                          )));
  }
}
