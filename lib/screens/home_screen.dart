import 'package:chat_app/widgets/contact_card.dart';
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
    return result['username'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Chats'),
          actions: [
            DropdownButton(
                icon: const Icon(Icons.more_vert),
                items: const [
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
                  }
                })
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(
                    '/chats/${FirebaseAuth.instance.currentUser!.uid}/contacts')
                .snapshots(),
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? const Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()]),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => FutureBuilder(
                      builder: (context, snp) {
                        if (snp.connectionState != ConnectionState.waiting) {
                          return ContactBubble(
                            contactName: snp.data,
                            contactId: snapshot.data!.docs[index].id,
                          );
                        }
                        return Container();
                      },
                      future: getName(snapshot.data!.docs[index].id),
                    ),
                  )));
  }
}
