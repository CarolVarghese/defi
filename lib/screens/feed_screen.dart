import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:de_fi_sample1/utils/colors.dart';
import 'package:de_fi_sample1/utils/global_variable.dart';
import 'package:de_fi_sample1/widgets/post_card.dart';
import 'package:de_fi_sample1/screens/search_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.fromRGBO(29, 127, 229, 1.0), Color.fromRGBO(
                    76, 187, 23, 1.0)])),

    child: Scaffold(
      backgroundColor:
      width > webScreenSize ? webBackgroundColor : Colors.transparent,
      appBar: width > webScreenSize
          ? null
          : AppBar(
        backgroundColor: Color.fromRGBO(29, 127, 229, 1.0),
        centerTitle: true,
        title: Text("De-Fi",
          style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              fontFamily: 'Pattaya',
              fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: primaryColor,
            ),
            onPressed: ()=> { const SearchScreen()},
          ),
          IconButton(
            icon: const Icon(
              Icons.messenger_outline,
              color: primaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    )
    );
  }
}