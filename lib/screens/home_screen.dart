import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/bubbles/contact_bubble.dart';
import 'package:chat_app/screens/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String res = '';
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
                    Provider.of<UserProvider>(context, listen: false)
                        .setLiveUser(FirebaseAuth.instance.currentUser!.uid);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const ProfileScreen()));
                  }
                })
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(
                    '/chats/${Provider.of<UserProvider>(context).userId}/contacts')
                .snapshots(),
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? const Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()]),
                  )
                : snapshot.data!.docs.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                            child: Text('There is no contacts',
                                style: TextStyle(color: Colors.grey[500]))),
                      )
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
                          future:
                              Provider.of<UserProvider>(context, listen: false)
                                  .getName(snapshot.data!.docs[index].id),
                        ),
                      )));
  }
}
