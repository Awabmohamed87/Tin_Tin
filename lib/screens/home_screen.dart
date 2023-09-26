import 'package:chat_app/providers/theme_provider.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/screens/appearance_screen.dart';
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
  void initState() {
    Provider.of<UserProvider>(context, listen: false).setNumberOfUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Provider.of<ThemeProvider>(context).secondryColor,
        drawer: MyDrawer(scaffoldKey: scaffoldKey),
        appBar: AppBar(
          leading: Center(
            child: InkWell(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Icon(
                      Icons.people,
                      size: 30,
                      color: Provider.of<ThemeProvider>(context).mainFontColor,
                    ),
                    if (Provider.of<UserProvider>(context).numOfRequests > 0)
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          '${Provider.of<UserProvider>(context).numOfRequests}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ],
                ),
                onTap: () => scaffoldKey.currentState!.openDrawer()),
          ),
          backgroundColor: Provider.of<ThemeProvider>(context).mainColor,
          title: Text('Chats',
              style: TextStyle(
                  color: Provider.of<ThemeProvider>(context).mainFontColor,
                  fontWeight: FontWeight.bold)),
          actions: [
            DropdownButton(
                icon: Icon(Icons.more_vert,
                    color: Provider.of<ThemeProvider>(context).mainFontColor),
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
                    value: 'appearance',
                    child: Row(
                      children: [
                        Icon(Icons.brush),
                        SizedBox(width: 10),
                        Text('Appearance')
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
                  ),
                ],
                onChanged: (value) {
                  if (value == 'logout') {
                    Provider.of<UserProvider>(context, listen: false).logout();
                  } else if (value == 'profile') {
                    Provider.of<UserProvider>(context, listen: false)
                        .setLiveUser(FirebaseAuth.instance.currentUser!.uid);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const ProfileScreen()));
                  } else if (value == 'appearance') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AppearanceScreen()));
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
